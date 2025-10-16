# Cardano dApp Template - Quick Reference

## Essential Commands

```bash
# Smart Contracts
npm run aiken:build      # Compile Aiken contracts
npm run aiken:check      # Type check contracts
npm run aiken:test       # Run Aiken tests

# Frontend
cd offchain
npm install              # Install dependencies
npm run dev              # Development server
npm run build            # Production build
npm run start            # Production server
npm run lint             # Lint and type check
```

## Project Structure at a Glance

```
├── lib/                        # Aiken smart contracts
│   ├── crowdfunding/          # Main contract logic
│   │   ├── types.ak          # Type definitions
│   │   └── utils.ak          # Utility functions
│   └── tests/                # Aiken unit tests
├── validators/                # Validator entry points
│   └── crowdfunding_b.ak     # Main validator
├── plutus.json               # Compiled contracts (auto-generated)
└── offchain/                 # Next.js frontend
    ├── app/                  # Pages (admin, backer, creator, hacker)
    ├── components/           # React components
    │   ├── buttons/         # Transaction builders
    │   ├── contexts/        # State management
    │   └── campaign/        # Campaign UI components
    ├── config/              # Configuration
    │   ├── lucid.ts        # Lucid initialization
    │   ├── script.ts       # Compiled contract imports
    │   └── crowdfunding.ts # Campaign config
    └── types/              # TypeScript types
```

## Key Files to Know

| File | Purpose |
|------|---------|
| `lib/crowdfunding/types.ak` | Smart contract type definitions |
| `lib/crowdfunding.ak` | Core validation logic |
| `validators/crowdfunding_b.ak` | Parameterized validator |
| `offchain/config/lucid.ts` | Blockchain connection setup |
| `offchain/config/script.ts` | Compiled contract reference |
| `offchain/components/contexts/wallet/` | Wallet state management |
| `offchain/components/buttons/campaign/` | Transaction builders |

## Common Tasks

### Add a New Campaign Action

1. **Update Aiken types** (`lib/crowdfunding/types.ak`):
```aiken
pub type CampaignAction {
  Cancel
  Finish
  Refund
  YourNewAction  // Add here
}
```

2. **Add validation logic** (`lib/crowdfunding.ak`):
```aiken
when (datum, campaign_action) is {
  // ... existing cases
  (Some(current_datum), YourNewAction) ->
    validate_your_new_action(tx, ...)
}
```

3. **Create button component** (`offchain/components/buttons/campaign/ButtonYourAction.tsx`)

4. **Rebuild**:
```bash
npm run aiken:build
cd offchain && npm run build
```

### Modify Datum Structure

1. Update `lib/crowdfunding/types.ak`
2. Update `offchain/types/crowdfunding.ts`
3. Update Data schemas in transaction builders
4. Rebuild contracts and frontend

### Change Network

Edit `offchain/config/lucid.ts`:
```typescript
export const network: Network = "Preview";  // or "Preprod" or "Mainnet"
```

## Environment Variables

Create `offchain/.env`:
```env
NEXT_PUBLIC_CARDANO_NETWORK=Preview
NEXT_PUBLIC_BLOCKFROST_API_KEY=your_key_here  # Optional
NEXT_PUBLIC_EXPLORER_URL=https://preview.cardanoscan.io
```

## Transaction Building Pattern

```typescript
import { useWallet } from "@/components/contexts/wallet/WalletContext";
import { Data } from "@lucid-evolution/lucid";

function MyComponent() {
  const [walletConnection] = useWallet();
  const { lucid, address } = walletConnection;

  async function buildTransaction() {
    // 1. Prepare datum
    const datum = Data.to(myData, MyDatumSchema);

    // 2. Build transaction
    const tx = await lucid!
      .newTx()
      .collectFrom([utxo])
      .pay.ToAddressWithData(scriptAddress, { kind: "inline", value: datum }, assets)
      .attach.Script(validator)
      .validFrom(Date.now())
      .complete();

    // 3. Sign and submit
    const signedTx = await tx.sign.withWallet().complete();
    const txHash = await signedTx.submit();

    return txHash;
  }
}
```

## Data Serialization

```typescript
import { Data } from "@lucid-evolution/lucid";

// Define schema matching Aiken
const CampaignDatum = Data.Object({
  name: Data.Bytes(),
  goal: Data.Integer(),
  deadline: Data.Integer(),
  creator: Data.Tuple([Data.Bytes(), Data.Bytes()]),
  state: Data.Integer(),
});

// Serialize to CBOR
const datum = Data.to(campaignData, CampaignDatum);

// Deserialize from CBOR
const campaignData = Data.from(datum, CampaignDatum);
```

## Querying Blockchain

```typescript
// Get UTXOs at address
const utxos = await lucid.utxosAt(address);

// Get UTXOs with specific asset
const campaignUtxos = utxos.filter(utxo =>
  utxo.assets[campaignId] === 1n
);

// Get datum from UTxO
if (utxo.datum) {
  const campaignData = Data.from(utxo.datum, CampaignDatum);
}
```

## Common Patterns

### Wallet Connection
```typescript
const [walletConnection, setWalletConnection] = useWallet();
const { lucid, address, wallet } = walletConnection;
```

### Transaction Status
```typescript
const [isSubmitting, setIsSubmitting] = useState(false);

async function handleTransaction() {
  setIsSubmitting(true);
  try {
    const txHash = await buildAndSubmitTx();
    toast.success(`Transaction submitted: ${txHash}`);
  } catch (error) {
    toast.error(`Transaction failed: ${error.message}`);
  } finally {
    setIsSubmitting(false);
  }
}
```

### Loading States
```typescript
import { Skeleton } from "@nextui-org/skeleton";

<Skeleton isLoaded={!!data}>
  <Component data={data} />
</Skeleton>
```

## Testing Workflow

### 1. Unit Tests (Aiken)
```bash
npm run aiken:test
```

### 2. Type Checking
```bash
cd offchain
npm run lint
```

### 3. Build Verification
```bash
npm run build
```

### 4. Manual Testing
1. Get testnet ADA from faucet
2. Connect wallet to Preview
3. Test all actions
4. Verify on explorer

## Troubleshooting

### Build fails after contract changes
```bash
npm run aiken:build
cd offchain
rm -rf .next
npm run build
```

### Transaction fails
- Check datum schema matches Aiken exactly
- Verify all required signers
- Check validity range
- Ensure sufficient UTxO

### Wallet not detected
- Install wallet extension
- Check network matches
- Wait for page load

## Network URLs

### Preview Testnet
- Faucet: https://docs.cardano.org/cardano-testnets/tools/faucet/
- Explorer: https://preview.cardanoscan.io
- Koios: https://preview.koios.rest

### Preprod Testnet
- Faucet: https://docs.cardano.org/cardano-testnets/tools/faucet/
- Explorer: https://preprod.cardanoscan.io
- Koios: https://preprod.koios.rest

### Mainnet
- Explorer: https://cardanoscan.io
- Koios: https://api.koios.rest

## Quick Tips

1. **Always test on testnet first**
2. **Match Aiken types exactly** (including field order)
3. **Use `'use client'`** for all Lucid imports
4. **Set validity ranges** to prevent replay attacks
5. **Verify transaction details** before signing
6. **Never expose private keys** - always use wallet APIs

## Resources

- [Aiken Docs](https://aiken-lang.org/)
- [Lucid Evolution](https://anastasia-labs.github.io/lucid-evolution/)
- [Cardano Developers](https://developers.cardano.org/)
- [CIP-30 Standard](https://cips.cardano.org/cip/CIP-30)

---

**Need more details?** See [TEMPLATE_README.md](./TEMPLATE_README.md)
