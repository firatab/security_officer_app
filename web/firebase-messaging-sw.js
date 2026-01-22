importScripts('firebase-config.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.5/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.5/firebase-messaging-compat.js');

if (!self.firebaseConfig || !self.firebaseConfig.apiKey) {
  console.warn('[firebase-messaging-sw] Missing firebaseConfig. Set values in firebase-config.js.');
} else {
  firebase.initializeApp(self.firebaseConfig);
  const messaging = firebase.messaging();

  messaging.onBackgroundMessage((payload) => {
    const notification = payload.notification || {};
    const title = notification.title || 'Notification';
    const options = {
      body: notification.body || '',
      data: payload.data || {},
    };

    self.registration.showNotification(title, options);
  });
}
