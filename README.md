# Chronograph

Building [10,000 baht digital](https://www.bangkokpost.com/topics/2666628/10-000-baht-digital-money-handout) with [ERC-7818](https://eips.ethereum.org/EIPS/eip-7818).

## Disclaimer

This is not official source code of 10,000 baht digital project form government.

## Specification

### Behaviors
- The Merchant **MUST NOT** allow to spend the token back to the citizen.
- The Merchant **MUST** use the unexpired balance with other merchant only.
- The Citizen **MUST NOT** allow spending/transfer to other citizen.

### Discuss to Requirement

- Project 10,000 baht digital propose idea to circulate the token _`n`_ times before off-ramp token into cash to ensure the token are being used and helping the economics, maybe it can be changed to other simple and effective idea e.g. restriction period of time and minimum withdraw amount.

### Approach

- Citizen balance independently manage by the [ERC-7818](https://eips.ethereum.org/EIPS/eip-7818).
- Merchant balance are whitelisted and all balance under merchant will be non-expire.
- Citizen geographical tight to the citizen blockchain address.
- Merchant geographical tight to the merchant blockchain address.

## Copyright

Copyright 2025 Sirawit Techavanitch. This repository release under the [GPL-3.0](./LICENSE) license