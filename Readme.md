#IOU

IOU is a simple app for tracking obligations of any kind in an auditable way.

In IOU users create obligations and track their fulfilment or modification over time.

There are two kinds of obligations: simple trades, bundles.

A simple trade is a for b.
A bundle is a set of simple trades which are conceptually linked.

IOU should have a simple database model, here's what I'm thinking:

The core data model should be the Transaction table, I'm thinking we can represent several different actions with a single table:

1. Create or Propose a trade
2. Confirm or Reject a trade
3. Modify a trade
4. Record settlement of one or both sides of the trade
5. Archive a trade

Here's my proposed columns/fields for the Transaction table:

1. TransactionId  // UUID
2. RevisionNumber // Incrementing number for every transaction
3. PartyA
4. PartyB
5. Author
6. Timestamp
7. Action         // JSON

The basic idea is to use an event sourced model, the transaction table will hold every action taken 
on a particular transaction and we will aggregate them on the server. Since individual transactions should have
a fairly small number of updates (less than 1k even for a long drawn out transaction) this should be an
efficient and flexible model.

The following actions should be available and have the following fields:

Create/Update/Propose action:

- items in the transaction (array)
	- item id (auto generated uuid)
	- item description (optional)
	- item name
	- item quantity (optional, defaults to 1)
	- alternate value (optional)
	- condition ("on cancel" or free form text) // TODO: lets leave this for a future version along with deadline, etc.
	- from party
	- to party

Confirm/Reject transaction:
Confirms or rejects the whole transaction, if both parties have confirmed the transaction it is considered agreed to and final

- revision number (optional, defaults to the latest version)
- confirm/reject (boolean)
- confirmation/rejection explanation

Fulfill/Confirm Fulfillment

- fulfillment id (auto generated to create a fulfillment, or a prior fulfillment id for confirm/update/reject of a fulfillment)
- items fulfilled (array)
	- item id
	- quantity fulfilled
	- fulfillment date
	- from who
	- to who
	- comment (optional)

Archive
(the user no longer cares about this transaction)

Note: if we want to support more than 2 parties to a deal then we could move the parties fields out into a separate table like so:

TransactionId
PartyId
RevisionNumber

The above table would basically be a cache/index generated from the actions themselves, since they include the to/from information already.

Note: I also thought about splitting the actions out into separate tables, but I thought the json model would be more flexible and simpler.


## How it will work

A user creates a transaction by auto-generating a transactionId and setting the action to create with some items. As part of creating the transaction the user can also pre-confirm it (they confirm it as final) and even pre-fulfill one or more items in the transaction (e.g. I owe you $50 that you loaned me yesterday would be recoreded as A sends B 50 (fulfilled) B sends A (unfulfilled), confirmed by B).

The counter party can now confirm or reject the transaction, if the confirm it, both parties see the transaction as confirmed, otherwise they see it as "rejected by [partyB]"

As items in the transaction are delivered either user can create a fulfillment marking that item as fulfilled, the other user can either mark the item as fulfilled or not fulfilled.

Finally when all items are fulfilled each user can "Archive" the transaction to hide it from their active transactions.


## Revision 2


After thinking about it, I think it will be simpler to just create a Users (many <-> many) Transactions (one <-> many) Actions


User:
- username
- name
- email
- profile

Transaction:
- users
- actions

Action:
- actor
- timestamp
- action


