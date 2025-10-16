# Using This Cardano dApp Template with Bolt.new

This document provides instructions for using this template as a starting point for new Cardano dApps in Bolt.new or similar AI-assisted development tools.

## Template Overview

This is a production-ready Cardano dApp template featuring:

- **Full-stack crowdfunding platform** as a working example
- **Next.js 14+** with TypeScript and App Router
- **Aiken smart contracts** with Plutus v3
- **Lucid Evolution v0.4+** for blockchain integration
- **NextUI components** with Tailwind CSS
- **Complete wallet integration** (Nami, Eternl, Flint, Yoroi)
- **Comprehensive documentation** and examples

## Quick Start Prompts for Bolt.new

### 1. Clone This Template

```
Create a new Cardano dApp based on the existing crowdfunding template in this repository.
The template includes:
- Complete Aiken smart contracts in /lib and /validators
- Next.js frontend in /offchain with wallet integration
- All necessary configurations and examples

Keep all existing files and structure intact. This will be the base for a new dApp.
```

### 2. Customize for Your Use Case

After cloning, use prompts like:

```
Modify this Cardano crowdfunding template to create a [YOUR USE CASE].
Keep the same technical stack (Aiken + Lucid Evolution + Next.js) but:
1. Update the smart contract logic in lib/ and validators/
2. Modify the frontend components in offchain/components/
3. Update types to match the new contract
4. Maintain the same security patterns and best practices

Example use cases:
- NFT marketplace
- Token vesting platform
- Decentralized voting system
- Staking rewards platform
- Multi-signature wallet
```

### 3. Extend Existing Features

```
Add [FEATURE] to this Cardano dApp while maintaining the existing crowdfunding functionality.

Examples:
- Add multi-asset token support
- Implement governance voting
- Add campaign categories and filtering
- Implement automated campaign milestones
- Add social features (comments, ratings)
```

## Key Files to Understand

### Smart Contracts (Aiken)

1. **lib/crowdfunding/types.ak** - Type definitions (Datum, Redeemer, State)
2. **lib/crowdfunding.ak** - Core validation logic
3. **validators/crowdfunding_b.ak** - Parameterized validator entry point
4. **aiken.toml** - Project configuration

### Frontend (Next.js)

1. **offchain/config/lucid.ts** - Lucid initialization
2. **offchain/config/script.ts** - Compiled contract imports
3. **offchain/components/contexts/** - Wallet and campaign state management
4. **offchain/components/buttons/** - Transaction builders for each action
5. **offchain/types/** - TypeScript type definitions

### Configuration

1. **offchain/next.config.js** - Next.js + WebAssembly config
2. **offchain/package.json** - Dependencies and scripts
3. **offchain/.env.example** - Environment variables template

## Development Workflow

### 1. Modify Smart Contracts

```bash
# Edit Aiken files in lib/ and validators/
# Test changes
npm run aiken:test

# Build contracts
npm run aiken:build

# This generates plutus.json with compiled code
```

### 2. Update Frontend

```typescript
// Update TypeScript types to match new contract
// Modify transaction builders in components/buttons/
// Update UI components as needed
```

### 3. Test and Build

```bash
cd offchain
npm install
npm run build
npm run dev
```

## Common Customization Patterns

### Adding a New Campaign Action

1. **Add Redeemer in types.ak**:
```aiken
pub type CampaignAction {
  Cancel
  Finish
  Refund
  YourNewAction  // Add here
}
```

2. **Add Validation Logic in crowdfunding.ak**:
```aiken
pub fn validate_spend_campaign(...) {
  when (datum, campaign_action) is {
    // ... existing cases
    (Some(current_datum), YourNewAction) ->
      validate_your_new_action(...)
  }
}
```

3. **Create Transaction Builder**:
```typescript
// offchain/components/buttons/campaign/ButtonYourNewAction.tsx
export default function ButtonYourNewAction() {
  // Build and submit transaction
}
```

### Changing Datum Structure

1. **Update Aiken types**:
```aiken
pub type CampaignDatum {
  name: ByteArray,
  goal: Lovelace,
  deadline: Int,
  creator: (PaymentKeyHash, StakeKeyHash),
  state: CampaignState,
  your_new_field: YourType,  // Add here
}
```

2. **Update TypeScript types**:
```typescript
// offchain/types/crowdfunding.ts
export interface CampaignDatum {
  name: string;
  goal: bigint;
  deadline: number;
  creator: [string, string];
  state: CampaignState;
  yourNewField: YourType;  // Add here
}
```

3. **Update Data schemas**:
```typescript
const CampaignDatum = Data.Object({
  name: Data.Bytes(),
  goal: Data.Integer(),
  deadline: Data.Integer(),
  creator: Data.Tuple([Data.Bytes(), Data.Bytes()]),
  state: Data.Integer(),
  yourNewField: YourDataType,  // Add here
});
```

## Security Checklist

When modifying this template:

- [ ] Validate all state transitions in Aiken contracts
- [ ] Ensure proper signature checks (creator, platform, backers)
- [ ] Verify UTxO consumption and minting logic
- [ ] Test with malicious inputs (use the Hacker panel)
- [ ] Set appropriate transaction validity ranges
- [ ] Test on Preview testnet before mainnet
- [ ] Review all datum and redeemer types match exactly
- [ ] Verify all error messages are clear and helpful

## Best Practices for AI-Assisted Development

### Good Prompts

✅ "Add NFT minting to campaigns, following the same security patterns as the existing state token minting"

✅ "Refactor the cancel campaign logic to allow partial refunds based on contribution percentage"

✅ "Add a new campaign type for milestone-based funding, maintaining backward compatibility"

### Prompts to Avoid

❌ "Rewrite everything from scratch" (loses battle-tested code)

❌ "Remove all the security checks" (introduces vulnerabilities)

❌ "Make it work without testing" (breaks existing functionality)

## Testing Your Changes

### 1. Aiken Unit Tests

```bash
npm run aiken:test
```

### 2. Frontend Type Checking

```bash
npm run lint
```

### 3. Build Verification

```bash
npm run build
```

### 4. Manual Testing on Testnet

1. Get testnet ADA from faucet
2. Connect wallet to Preview testnet
3. Test all transaction flows
4. Verify on Cardano explorer

## Common Issues and Solutions

### Issue: Build fails after contract changes

**Solution**:
1. Run `npm run aiken:build`
2. Update TypeScript types to match new contract
3. Clear Next.js cache: `rm -rf .next`

### Issue: Transaction fails with "Script execution failed"

**Solution**:
1. Verify datum schema matches Aiken types exactly
2. Check field order (must match Aiken definition)
3. Ensure all required signatories are present
4. Verify validity range is set correctly

### Issue: Wallet connection not working

**Solution**:
1. Ensure wallet extension is installed
2. Check `typeof window !== 'undefined'` guards
3. Verify correct network (Preview/Preprod/Mainnet)

## Resources

- **Template Documentation**: See TEMPLATE_README.md
- **Aiken Docs**: https://aiken-lang.org/
- **Lucid Evolution**: https://anastasia-labs.github.io/lucid-evolution/
- **Cardano Developers**: https://developers.cardano.org/

## Support

This template is designed to be self-documenting. Key resources:

1. **TEMPLATE_README.md** - Complete usage guide
2. **CARDANO_DAPP_GENERATION_GUIDE.md** - Technical requirements reference
3. **Inline comments** - Throughout the codebase
4. **Example implementations** - Working crowdfunding platform

---

**Pro Tip**: When asking AI to modify this template, always reference the existing code patterns and security practices. This ensures consistency and maintains the battle-tested architecture.
