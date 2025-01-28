# Chronograph

Building [10,000 baht digital](https://www.bangkokpost.com/topics/2666628/10-000-baht-digital-money-handout) with [ERC-7818](https://eips.ethereum.org/EIPS/eip-7818).

## Disclaimer

This is not official source code of 10,000 baht digital project form government.

## Specification

### Discuss to Requirement

- Project proposes restriction to spending within 4 kilometers radius ensure that the tokens are spent within the local merchant.it can use `Circle2D` to achieve this requirement, It's possible that some citizen can not find the merchant within 4 km radius. It **SHOULD** move to city, district, province, or postcode instead.  
_Note: Not sure that Merchant applied the same rule as in the citizen._
  
- Project propose idea to circulate the token **MUST** be spent _`n`_ times before the token can be off-ramp into cash to ensure the token are being used and contribute to the economy, maybe it can be changed to other simple and effective idea e.g. restriction period of time and minimum withdraw amount.

### Behaviors

- The Citizen **MUST** spend tokens exclusively at merchants within a 4 km radius from the citizen's registered location.
- The Citizen **MUST NOT** or share tokens with other citizens.
- The Merchant **MUST NOT** allow to spend the token back to the citizen. Allow only spent or transferred only to other merchants.

### Approach

- Citizen balance independently manage by the [ERC-7818](https://eips.ethereum.org/EIPS/eip-7818).
- Merchant balance are `whitelisted` and all balance under merchant will be `non-expire`.
- Citizen and Merchant `geographical` tight to the blockchain address in `Circle2D`.
- Restriction `cashout` function by access control or authorized only.

## Copyright

Copyright 2025 Sirawit Techavanitch. This repository release under the [GPL-3.0](./LICENSE) license