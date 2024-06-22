## RuneTokenClone

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

