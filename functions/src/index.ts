import * as functions from "firebase-functions/v1";
import * as admin from "firebase-admin";


admin.initializeApp();

export const addUserToDatabase = functions.auth.user().onCreate((user: any) => {
  const userData = {
    uid: user.uid,
    email: user.email || "",
    displayName: user.displayName || "",
    photoURL: user.photoURL || "",
    balance: 2200,
    createdAt: admin.database.ServerValue.TIMESTAMP,
    updatedAt: admin.database.ServerValue.TIMESTAMP,
  };

  return admin.database().ref(`/users/${user.uid}`).set(userData);
});

export const removeUserFromDatabase = functions.auth.user().onDelete((user : any) => {
  return admin.database().ref(`/users/${user.uid}`).remove();
});
