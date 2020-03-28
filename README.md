# FoB_DaiRich
DaiRich self-managed bank account

What If?

You could have your own account that is always earning you Dai – in the background – in real time!

With an automated allocation for investing and with thresholds and limits that YOU control

No need to lock your Dai away to earn interest

## Summary

This project is a proof of concept for self managed bank account in which if the balance of an account is higher than a threshold
that exceeded is invested automatically. 
If the balance goes below another threshold the account is recovered from the investement made earlier if there were any and it keeps
always a minimum balance in the account for daily usage.

Lastly, if the account is overdraft, i.e. balance goes below 0, the system will ask for a flash loan so we could pay a small amount
and then pay it back later.

## Kovan details
LendingPoolCore 0x95D1189Ed88B380E319dF73fF00E479fcc4CFa45
LendingPool 0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5
DAI: https://kovan.etherscan.io/address/0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD
aDAI: https://kovan.etherscan.io/address/0x58AD4cB396411B691A9AAb6F74545b2C5217FE6a


## Instructions
Install dependencies
`$ npm install
`

Compile

`$ truffle compile
`

Deploy

`$ truffle migrate --network kovan
`

## Workflow
1. Deploy the smart contract
2. Enroll an address using the enroll function
3. Execute DAI Approve function so you could transfer DAI to Hybrid Bank (this smart contract)
4. Execute Hybrid Bank deposit function to transfer DAI to Hybrid Bank where thresholds and conditions will apply 
