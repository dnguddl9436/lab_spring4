package com.firebase.realtimeDB;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.MutableData;
import com.google.firebase.database.Transaction;

public class Test {

	public void transactionData() {
		final FirebaseDatabase database = FirebaseDatabase.getInstance();
		DatabaseReference ref = database.getReference();

		DatabaseReference upvotesRef = ref.child("board/1/bm_like");
		upvotesRef.runTransaction(new Transaction.Handler() {
		  @Override
		  public Transaction.Result doTransaction(MutableData mutableData) {
		    Integer currentValue = mutableData.getValue(Integer.class);
		    if (currentValue == null) {
		      mutableData.setValue(1);
		    } else {
		      mutableData.setValue(currentValue + 1);
		    }

		    return Transaction.success(mutableData);
		  }

		  @Override
		  public void onComplete(DatabaseError databaseError, boolean committed, DataSnapshot dataSnapshot) {
		    if (databaseError != null) {
		        System.out.println("Data could not be saved " + databaseError.getMessage());
		      } else {
		        System.out.println("Data saved successfully.");
		      }
		  }
		});
		System.out.println("trdt");
	}

}
