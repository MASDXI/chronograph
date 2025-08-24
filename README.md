# chronograph-evm

<h1 align="center">
<img src="./assets/banner.jpeg" width="360"/>
</h1>

Project `chronograph-evm` explores the design of a [10,000 Baht Digital Wallet](https://digitalwallet.go.th) by applying relevant Ethereum standards, including [ERC-6372](https://eips.ethereum.org/EIPS/eip-6372) and [ERC-7818](https://eips.ethereum.org/EIPS/eip-7818).

> [!Important]
> This is not official source code of Digital Wallet Project form government.

### Requirement

The system is governed by the following requirements. The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “NOT RECOMMENDED”, “MAY”, and “OPTIONAL” are to be interpreted as described in RFC 2119 and RFC 8174.

- Digital money **SHALL** expire 6 months after the date of receipt.
- Digital money **MUST** only be spent at registered merchants participating in the program.
- Digital money **MUST** only be used within the recipient’s domicile district.
- Digital money **MUST** only be withdrawn or converted into cash after it has been circulated and spent at least 3 times.

### Implementation Approaches

Two possible approaches are considered for managing the token life span

#### [ERC-7818](https://eips.ethereum.org/EIPS/eip-7818) Approach
 - Supports per-user issuance, meaning each citizen’s 6-month validity period begins at the time of receipt.
 - Suitable if on-boarding occurs at different times.

#### [ERC-6372](https://eips.ethereum.org/EIPS/eip-6372) Approach

- Instead of expiring tokens, the token itself has no lifespan.
Transferability is restricted within a defined period using time-based clocks.
- Ensures all citizens share the same start and end date for usability.

<h1 align="center">
<img src="./assets/transfer-flow.png"/>
</h1>

When citizen transfer Digital Token to merchant expirable token will be burned and minting Merchant Digital Token to merchant at index [0] balance of merchant

<h1 align="center">
<img src="./assets/merc-transfer-flow.png"/>
</h1>

When merchants transfer tokens between each other, the circulation index increases to track spending cycles

```
Transfer Cycle 0: Burning Digital Token → Mint Merchant Digital Token
Transfer Cycle 1: Spender balance[0] → Receiver balance[1]
Transfer Cycle 2: Spender balance[1] → Receiver balance[2]  
Transfer Cycle 3: Spender balance[2] → Receiver balance[3]
Transfer Cycle 4+: Spender balance[3] → Receiver balance[3] (stays at final tier)
```

#### Additional Rules
- Tokens held by citizens **MUST NOT** be transferable from one citizen to another.
- Tokens held by merchants **MUST NOT** be transferable back to citizens. 
- Tokens held by merchants **MUST** be non-expiring.
- Transfer **MUST** be validated to ensure that both the spender and the recipient are located within the same district.
- Circulation tracking (e.g., “spent at least 3 times before cash-out”) **MUST** be implemented.

## Appendix

### Other Possible Solutions

- [ERC-1400: The Security Token Standard](https://www.polymath.network/erc-1400)
- [ERC-3643: T-REX - Token for Regulated EXchange](https://eips.ethereum.org/EIPS/eip-3643)
- [ERC-7291: Purpose bound money](https://eips.ethereum.org/EIPS/eip-7291)


## Copyright

`chronograph-evm` Copyright 2025 Sirawit Techavanitch. This repository release under the [GPL-3.0](./LICENSE) license