# Cardano dApp Template - Production Ready

A complete, production-ready template for building Cardano blockchain decentralized applications using Next.js 14+, Lucid Evolution v0.4+, and Aiken (Plutus v3). This template includes a fully functional crowdfunding platform demonstrating all key Cardano dApp patterns.

## Features

- **Frontend**: Next.js 14+ with TypeScript and App Router
- **Smart Contracts**: Aiken with Plutus v3 (parameterized validators)
- **Blockchain Integration**: Lucid Evolution v0.4+ with Koios provider
- **Wallet Support**: All CIP-30 compatible wallets (Nami, Eternl, Flint, Yoroi, etc.)
- **UI Components**: NextUI with Tailwind CSS
- **State Management**: React Context API
- **Dark Mode**: Built-in theme switching with next-themes

## What's Included

This template includes a complete crowdfunding platform with:

- **Create Campaign**: Mint campaign NFT with goal and deadline
- **Support Campaign**: Backers contribute ADA to campaigns
- **Cancel Campaign**: Creator or platform can cancel campaigns
- **Finish Campaign**: Collect funds when goal is reached
- **Refund Campaign**: Backers get refunds if campaign fails
- **Admin Panel**: Platform admin features for managing campaigns
- **Hacker Panel**: Security testing tools to verify contract security

## Quick Start

### Prerequisites

- Node.js 18+ and npm/pnpm
- Aiken v1.1.9+ installed globally
- A Cardano wallet extension (Nami, Eternl, Flint, or Yoroi)
- Cardano Preview testnet ADA (get from [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/))

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd cardano-dapp-template
```

2. Install dependencies:
```bash
cd offchain
npm install
# or
pnpm install
```

3. Build Aiken contracts:
```bash
npm run aiken:build
```

4. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

5. Run the development server:
```bash
npm run dev
```

6. Open [http://localhost:3000](http://localhost:3000) in your browser

## Project Structure

```
cardano-dapp-template/
├── lib/                          # Aiken smart contract library
│   ├── crowdfunding/            # Crowdfunding module
│   │   ├── types.ak            # Type definitions
│   │   └── utils.ak            # Utility functions
│   ├── tests/                   # Aiken test files
│   └── crowdfunding.ak          # Main validation logic
├── validators/                   # Aiken validators
│   └── crowdfunding_b.ak        # Campaign validator
├── offchain/                     # Next.js frontend
│   ├── app/                     # Next.js App Router pages
│   │   ├── admin/              # Admin dashboard
│   │   ├── backer/             # Backer interface
│   │   ├── creator/            # Creator interface
│   │   └── hacker/             # Security testing tools
│   ├── components/              # React components
│   │   ├── buttons/            # Action buttons
│   │   ├── campaign/           # Campaign components
│   │   ├── contexts/           # React contexts
│   │   └── pages/              # Page-specific components
│   ├── config/                  # Configuration files
│   │   ├── lucid.ts            # Lucid setup
│   │   ├── script.ts           # Compiled contracts
│   │   └── crowdfunding.ts     # Campaign config
│   ├── types/                   # TypeScript types
│   └── styles/                  # Global styles
├── aiken.toml                   # Aiken project config
├── plutus.json                  # Compiled contracts
└── README.md                    # This file
```

## Configuration

### Environment Variables

Create `.env` file in the `offchain` directory:

```env
# Cardano Network (Preview, Preprod, or Mainnet)
NEXT_PUBLIC_CARDANO_NETWORK=Preview

# Optional: Blockfrost API Key for alternative provider
NEXT_PUBLIC_BLOCKFROST_API_KEY=your_api_key_here

# Optional: Explorer URL for transaction links
NEXT_PUBLIC_EXPLORER_URL=https://preview.cardanoscan.io
```

### Aiken Configuration

The `aiken.toml` file includes parameterized validator configuration:

```toml
[config.default]
state_token = "STATE_TOKEN"
```

You can modify this for different campaign types or token names.

## Smart Contract Architecture

### Validators

The crowdfunding validator is a parameterized multi-purpose validator that handles:

1. **Minting Policy**: Creates campaign NFT state token
2. **Spending Validator**: Controls campaign funds and state transitions

### Key Concepts

#### Campaign States
- **Running**: Campaign is active and accepting contributions
- **Finished**: Campaign reached goal, creator can collect funds
- **Cancelled**: Campaign was cancelled, backers can get refunds

#### Datum Types
- **CampaignDatum**: Campaign metadata (name, goal, deadline, creator, state)
- **BackerDatum**: Backer contribution record (payment key hash, stake key hash)

#### Redeemers
- **Cancel**: Cancel a running campaign
- **Finish**: Finish campaign and distribute funds to creator
- **Refund**: Refund backer contributions

## Development Guide

### Running Aiken Tests

```bash
npm run aiken:test
```

### Building Smart Contracts

```bash
npm run aiken:build
```

This generates `plutus.json` with compiled Plutus Core code.

### Type Checking

```bash
npm run lint
```

### Building for Production

```bash
npm run build
```

## Key Implementation Patterns

### 1. Wallet Connection

```typescript
// Using the WalletContext
import { useWallet } from "@/components/contexts/wallet/WalletContext";

function MyComponent() {
  const [walletConnection] = useWallet();
  const { lucid, address, wallet } = walletConnection;

  // Use lucid for transactions
}
```

### 2. Building Transactions

```typescript
// Example from ButtonCreateCampaign.tsx
const tx = await lucid
  .newTx()
  .collectFrom([nonce])
  .mintAssets({ [campaignId]: 1n }, campaignDatumData)
  .pay.ToAddressWithData(
    script_address,
    { kind: "inline", value: campaignDatumData },
    { [campaignId]: 1n }
  )
  .validTo(valid_to)
  .attach.MintingPolicy(campaign_policy)
  .complete();
```

### 3. Querying UTXOs

```typescript
// Query campaign UTXOs
const utxos = await lucid.utxosAt(script_address);
```

### 4. Data Serialization

```typescript
import { Data } from "@lucid-evolution/lucid";

// Serialize datum
const CampaignDatum = Data.Object({
  name: Data.Bytes(),
  goal: Data.Integer(),
  deadline: Data.Integer(),
  creator: Data.Tuple([Data.Bytes(), Data.Bytes()]),
  state: Data.Integer(),
});

const datum = Data.to(campaignData, CampaignDatum);
```

## Security Best Practices

### 1. Always Use Testnet First
Test all transactions on Preview or Preprod networks before deploying to mainnet.

### 2. Validate Datums
Always validate that datum types match your Aiken contract expectations.

### 3. Set Validity Ranges
Include `validFrom` and `validTo` constraints to prevent replay attacks.

### 4. Check Transaction Details
Verify all inputs, outputs, and values before signing transactions.

### 5. Never Expose Private Keys
Always use wallet APIs for signing, never handle private keys directly.

## Common Issues and Solutions

### Issue: "parseVec could not cast the value" build error

**Solution**:
- Ensure Next.js webpack config externalizes Lucid on server side
- Use `'use client'` directive in all files importing Lucid
- Verify WebAssembly support is configured correctly

### Issue: Wallet not detected

**Solution**:
- Check that wallet extension is installed and enabled
- Verify `typeof window !== 'undefined'` before accessing wallet
- Wait for page load before checking wallet availability

### Issue: Transaction fails with "Script execution failed"

**Solution**:
- Verify datum schema exactly matches Aiken types (including field order)
- Check that all required signatures are present
- Ensure validity range is set correctly
- Verify UTXOs have sufficient ADA for fees

### Issue: "UTxO not found at script address"

**Solution**:
- Query UTXOs before attempting to spend them
- Verify you're on the correct network (Preview vs Preprod vs Mainnet)
- Wait for transaction confirmation before querying

## Testing on Testnet

1. Get testnet ADA from [Cardano Testnet Faucet](https://docs.cardano.org/cardano-testnets/tools/faucet/)
2. Connect your wallet to Preview testnet
3. Create a test campaign
4. Test all campaign actions (support, cancel, finish, refund)
5. Verify transactions on [Cardano Explorer](https://preview.cardanoscan.io)

## Deployment Checklist

- [ ] Test all transactions on Preview testnet
- [ ] Verify Aiken contracts with `npm run aiken:check`
- [ ] Build Next.js with no errors: `npm run build`
- [ ] Update environment variables for production
- [ ] Test wallet connections on deployed site
- [ ] Update explorer URLs to mainnet
- [ ] Document any custom configuration
- [ ] Perform security audit of smart contracts

## Customization Guide

### Modifying Campaign Logic

1. Edit Aiken validators in `lib/` and `validators/`
2. Update types in `lib/crowdfunding/types.ak`
3. Rebuild contracts: `npm run aiken:build`
4. Update TypeScript types in `offchain/types/`
5. Update transaction builders in `offchain/components/buttons/`

### Adding New Campaign Types

1. Add new state to `CampaignState` in `types.ak`
2. Add new redeemer to `CampaignAction`
3. Implement validation logic in `crowdfunding.ak`
4. Update frontend components
5. Add tests in `lib/tests/`

### Changing UI Theme

Edit `offchain/tailwind.config.js` and `offchain/styles/globals.css`

## Resources

- [Lucid Evolution Documentation](https://anastasia-labs.github.io/lucid-evolution/)
- [Aiken Language Documentation](https://aiken-lang.org/)
- [Cardano Developer Portal](https://developers.cardano.org/)
- [CIP-30 Wallet Standard](https://cips.cardano.org/cip/CIP-30)
- [Koios API Documentation](https://koios.rest/)
- [NextUI Components](https://nextui.org/)

## Support

For issues and questions:
- Check the [Common Issues](#common-issues-and-solutions) section
- Review the example crowdfunding implementation
- Consult Aiken and Lucid Evolution documentation

## License

Apache-2.0

## Credits

Built with:
- [Next.js](https://nextjs.org/)
- [Lucid Evolution](https://github.com/anastasia-labs/lucid-evolution)
- [Aiken](https://aiken-lang.org/)
- [NextUI](https://nextui.org/)
- [Tailwind CSS](https://tailwindcss.com/)

---

**Note**: This is a template for educational and development purposes. Always perform thorough security audits before deploying to mainnet with real funds.
