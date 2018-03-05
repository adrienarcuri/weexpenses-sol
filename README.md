Test it in Remix :

CreateContract by the owner Alice which will be also a participant :
```javascript
"Alice"
// "0xca35b7d915458ef540ade6068dfe2f44e8fa733c"
```


CreateParticipant Bob :
```javascript
"Bob", "0x14723a09acff6d2a60dcdf7aa4aff308fddc160c"

"Cris", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"

"Dede", "0x583031d1113ad414f02576bd6afabfb302140225"
```

CreateExpense payed by Alice for Bob:

```javascript
"Expense1", 10000, 1519135382, "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", ["0xca35b7d915458ef540ade6068dfe2f44e8fa733c","0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", "0x583031d1113ad414f02576bd6afabfb302140225"]

"Expense2", 5000, 1519135382, "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db", ["0x14723a09acff6d2a60dcdf7aa4aff308fddc160c", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c", "0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"]
"Dede", "0x583031d1113ad414f02576bd6afabfb302140225"
```

setAgreement :
```javascript
0, true
0, false
```

createRefund : 
```javascript
0, true
0, false
```