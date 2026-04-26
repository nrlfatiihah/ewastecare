const admin = require("firebase-admin");
const {logger} = require("firebase-functions");
const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {setGlobalOptions} = require("firebase-functions/v2");

admin.initializeApp();
setGlobalOptions({region: "asia-southeast1", maxInstances: 10});

async function getAdminNotificationTokens() {
  const snapshot = await admin
      .firestore()
      .collection("Admins")
      .where("IsDeveloper", "==", true)
      .get();

  const tokens = [];
  snapshot.forEach((doc) => {
    const data = doc.data() || {};
    const docTokens = Array.isArray(data.FcmTokens) ? data.FcmTokens : [];
    tokens.push(...docTokens);
  });

  return [...new Set(tokens.filter((token) => token && token.trim()))];
}

async function sendNotificationToAdminTokens(tokens, payload) {
  if (!Array.isArray(tokens) || tokens.length === 0) {
    return;
  }

  await admin.messaging().sendEachForMulticast({
    tokens,
    notification: {
      title: payload.title,
      body: payload.body,
    },
    data: payload.data || {},
    android: {
      priority: "high",
    },
    apns: {
      headers: {
        "apns-priority": "10",
      },
    },
  });
}

async function getProfileByUid(uid) {
  const usersRef = admin.firestore().collection("Users").doc(uid);
  const adminsRef = admin.firestore().collection("Admins").doc(uid);

  const [userDoc, adminDoc] = await Promise.all([usersRef.get(), adminsRef.get()]);

  if (userDoc.exists) {
    return {ref: usersRef, data: userDoc.data() || {}};
  }

  if (adminDoc.exists) {
    return {ref: adminsRef, data: adminDoc.data() || {}};
  }

  return null;
}

function extractName(profile) {
  const firstName = (profile.FirstName || "").toString().trim();
  const lastName = (profile.LastName || "").toString().trim();
  const username = (profile.Username || "").toString().trim();
  const fullName = `${firstName} ${lastName}`.trim();
  return fullName || username || "New message";
}

exports.notifyNewChatMessage = onDocumentCreated(
    "Conversations/{conversationId}/Messages/{messageId}",
    async (event) => {
      const message = event.data ? event.data.data() : null;
      if (!message) return;

      const senderId = (message.senderId || "").toString();
      const text = (message.text || "").toString().trim();
      const conversationId = (event.params.conversationId || "").toString();
      if (!senderId || !conversationId) return;

      const conversationRef = admin.firestore().collection("Conversations").doc(conversationId);
      const conversationDoc = await conversationRef.get();
      if (!conversationDoc.exists) return;

      const conversation = conversationDoc.data() || {};
      const participants = Array.isArray(conversation.participants) ? conversation.participants : [];
      const recipientId = participants.find((id) => id && id !== senderId);
      if (!recipientId) return;

      const recipientProfile = await getProfileByUid(recipientId);
      if (!recipientProfile) {
        logger.warn("Recipient profile not found", {conversationId, recipientId});
        return;
      }

      const recipientTokens = Array.isArray(recipientProfile.data.FcmTokens) ? recipientProfile.data.FcmTokens : [];
      if (recipientTokens.length === 0) {
        logger.info("No tokens available for recipient", {conversationId, recipientId});
        return;
      }

      const senderProfile = await getProfileByUid(senderId);
      const senderName = senderProfile ? extractName(senderProfile.data) : "New message";

      const response = await admin.messaging().sendEachForMulticast({
        tokens: recipientTokens,
        notification: {
          title: senderName,
          body: text || "You have a new message",
        },
        data: {
          type: "chat",
          conversationId,
          senderId,
          senderName,
        },
        android: {
          priority: "high",
        },
        apns: {
          headers: {
            "apns-priority": "10",
          },
        },
      });

      const invalidTokenCodes = new Set([
        "messaging/registration-token-not-registered",
        "messaging/invalid-registration-token",
      ]);

      const invalidTokens = [];
      response.responses.forEach((result, index) => {
        if (result.success) return;
        const code = result.error && result.error.code ? result.error.code : "";
        if (invalidTokenCodes.has(code)) {
          invalidTokens.push(recipientTokens[index]);
        }
      });

      if (invalidTokens.length > 0) {
        await recipientProfile.ref.set({
          FcmTokens: admin.firestore.FieldValue.arrayRemove(...invalidTokens),
        }, {merge: true});
      }

      logger.info("Chat notification sent", {
        conversationId,
        recipientId,
        totalTokens: recipientTokens.length,
        successCount: response.successCount,
        failureCount: response.failureCount,
      });
    },
);

exports.notifyDeveloperOnNewAdminRequest = onDocumentCreated(
    "Admins/{adminId}",
    async (event) => {
      const adminDoc = event.data ? event.data.data() : null;
      if (!adminDoc) return;

      const isApproved = adminDoc.Approved === true;
      if (isApproved) return;

      const adminId = (event.params.adminId || "").toString();
      const adminEmail = (adminDoc.Email || "").toString().trim();
      const adminName = (adminDoc.Username || "New admin request").toString().trim();

      const tokens = await getAdminNotificationTokens();
      if (tokens.length === 0) {
        logger.info("No developer tokens available for new admin request", {
          adminId,
          adminEmail,
        });
        return;
      }

      await sendNotificationToAdminTokens(tokens, {
        title: "New admin request",
        body: `${adminName} (${adminEmail || "no email"}) is waiting for approval`,
        data: {
          type: "admin_request",
          adminId,
          adminEmail,
          adminName,
        },
      });

      logger.info("Developer notified about new admin request", {
        adminId,
        adminEmail,
        tokenCount: tokens.length,
      });
    },
);
