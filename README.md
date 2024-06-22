## RuneToken Claiming Platform
### Overview

This contract allows founders to manage whitelist rounds for token claims and for users to claim their allocated tokens. The platform includes options to set fees for claiming, with a distribution of fees to both the site owner and founders.

### Features
1. **Whitelist Management**:

- Create multiple whitelist rounds.
- Upload address lists for each round.
- Set fees for each round.

2. **Claiming Tokens**:

- Users can claim their allocated tokens by paying the required fees.

## Getting Started
### Deployment
1. **Deploy the RuneToken contract using Foundry.**
```
forge script script/DeployRune.s.sol --broadcast --rpc-url <YOUR_RPC_URL> --private-key <YOUR_PRIVATE_KEY>
```
2. **Note the deployed contract address.**

### Using the Dashboard
1. **Create Whitelist Round:**

- Go to the "Create Round" section.
- Enter the fee amount (or set it to 0 for free claims).
- Submit to create the round.

2. **Add Addresses to Whitelist:**

- Go to the "Manage Whitelist" section.
- Upload a CSV file with addresses or enter them manually.
- Submit to add addresses to the whitelist for a specific round.

3. **Set Fees:**

- Go to the "Set Fees" section.
- Enter the fee amount for the desired round.
- Submit to set the fee.

4. **Claim Tokens:**

- Go to the "Claim Tokens" section.
- Enter the amount to claim.
- Pay the required fee and network gas.
- Submit to claim tokens.

### Demo
A live demo of the platform can be accessed at [Fleek URL].

<hr>

## Workflow

1. Founder inscribes full supply of RUNE token to their wallet:
 - This is handled by the contract's constructor, which mints the full supply to the `siteOwner`.

2. Dashboard to create whitelist rounds and upload address list:
 - The `createWhitelistRound` function allows the founder to create multiple whitelist rounds.
 - The `addToWhitelist` function allows the founder to add addresses to each whitelist round.

3. Option to add a fee on each whitelist/public round or mark them as free claims:
 - The `setServiceFee` function allows the founder to set a fee for each round.
 - Fee management is included within the claim function.

4. Fee distribution (10% to site owner, 90% to founders):
 - This logic is implemented in the claim function, where the fee is split and distributed accordingly.

5. Normal users pay network fees for distribution + additional fee if required:
 - The claim function ensures that users pay the required fee along with any network fees for claiming tokens.

<hr>
