# Comprehensive Prompt for Cardano dApp Generation (Lucid Evolution + Aiken)

## 🎯 Primary Objective
Create a full-stack Cardano blockchain decentralized application with:
- **Frontend**: Next.js 15+ with TypeScript
- **Smart Contracts**: Aiken (Plutus v3)
- **Blockchain Integration**: Lucid Evolution v0.4+
- **Styling**: Tailwind CSS + NextUI/ShadcN
- **State Management**: React Context API
- **Wallet Integration**: CIP-30 compatible wallets (Nami, Eternl, Flint, Yoroi)

---

## 📋 Critical Technical Requirements

### 1. Next.js Configuration (MUST HAVE)

**Use Next.js 15+ and configure for WebAssembly support:**

```javascript
// next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Enable Turbopack for faster builds (Next.js 15+)
  turbopack: {
    resolveAlias: {
      // Prevent server-side imports of browser-only modules
      'lucid-cardano': './src/lib/lucid-browser-only.ts',
    },
  },

  // Proxy Cardano API endpoints to avoid CORS
  async rewrites() {
    return [
      {
        source: '/koios/:path*',
        destination: 'https://preview.koios.rest/api/v1/:path*', // Cardano testnet
      },
      {
        source: '/blockfrost/:path*',
        destination: 'https://cardano-preview.blockfrost.io/api/v0/:path*',
      },
    ];
  },

  // Essential WebAssembly configuration for Lucid Evolution
  webpack: (config, { isServer }) => {
    // Enable WebAssembly support
    config.experiments = {
      ...config.experiments,
      asyncWebAssembly: true,
      topLevelAwait: true,
      layers: true,
      syncWebAssembly: true, // Add sync WASM support
    };

    // Exclude WASM from server-side builds to avoid parse errors
    if (isServer) {
      config.externals = config.externals || [];
      config.externals.push({
        '@lucid-evolution/lucid': '@lucid-evolution/lucid',
        '@lucid-evolution/uplc': '@lucid-evolution/uplc',
      });
    }

    // Fix for WebAssembly modules with Reference Types
    config.module.rules.push({
      test: /\.wasm$/,
      type: 'asset/resource',
    });

    return config;
  },

  // Optimize for client-side rendering
  reactStrictMode: true,
  swcMinify: true,
};

module.exports = nextConfig;
```

### 2. Package.json Dependencies

```json
{
  "name": "cardano-dapp",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev --turbo",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "aiken:build": "cd contracts && aiken build",
    "aiken:check": "cd contracts && aiken check",
    "aiken:test": "cd contracts && aiken check -v"
  },
  "dependencies": {
    "@lucid-evolution/lucid": "^0.4.29",
    "next": "^15.5.0",
    "react": "^18.3.1",
    "react-dom": "^18.3.1",
    "next-themes": "^0.4.0",
    "react-toastify": "^11.0.0",
    "@nextui-org/react": "^2.6.0",
    "framer-motion": "^11.13.0",
    "tailwind-variants": "^0.2.0",
    "clsx": "^2.1.1"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "@types/react": "^18.3.0",
    "@types/react-dom": "^18.3.0",
    "typescript": "^5.6.0",
    "tailwindcss": "^3.4.0",
    "autoprefixer": "^10.4.0",
    "postcss": "^8.4.0",
    "eslint": "^9.0.0",
    "eslint-config-next": "^15.5.0"
  }
}
```

### 3. Lucid Evolution Setup (Client-Side Only)

**CRITICAL**: Lucid must be initialized on the client side only, never on the server.

```typescript
// lib/lucid-config.ts
'use client';

import { Lucid, Blockfrost, Network } from '@lucid-evolution/lucid';

// Cardano network configuration
export const NETWORK: Network = 'Preview'; // or 'Preprod' or 'Mainnet'

// Initialize Lucid with Blockfrost provider
export async function initLucid(blockfrostApiKey: string) {
  try {
    const lucid = await Lucid(
      new Blockfrost(
        `https://cardano-preview.blockfrost.io/api/v0`,
        blockfrostApiKey
      ),
      NETWORK
    );

    return lucid;
  } catch (error) {
    console.error('Failed to initialize Lucid:', error);
    throw error;
  }
}

// Wallet connection helper
export async function connectWallet(lucid: Lucid, walletName: string) {
  if (typeof window === 'undefined') {
    throw new Error('Wallet connection must be called from browser');
  }

  const walletApi = await window.cardano?.[walletName]?.enable();
  if (!walletApi) {
    throw new Error(`${walletName} wallet not found`);
  }

  lucid.selectWallet.fromAPI(walletApi);
  const address = await lucid.wallet().address();

  return { address, walletApi };
}
```

### 4. React Context for Wallet Management

```typescript
// contexts/WalletContext.tsx
'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { Lucid } from '@lucid-evolution/lucid';
import { initLucid, connectWallet } from '@/lib/lucid-config';

interface WalletContextType {
  lucid: Lucid | null;
  address: string | null;
  walletName: string | null;
  isConnecting: boolean;
  connect: (walletName: string) => Promise<void>;
  disconnect: () => void;
}

const WalletContext = createContext<WalletContextType | undefined>(undefined);

export function WalletProvider({ children }: { children: ReactNode }) {
  const [lucid, setLucid] = useState<Lucid | null>(null);
  const [address, setAddress] = useState<string | null>(null);
  const [walletName, setWalletName] = useState<string | null>(null);
  const [isConnecting, setIsConnecting] = useState(false);

  useEffect(() => {
    // Initialize Lucid on mount (client-side only)
    if (typeof window !== 'undefined') {
      const blockfrostKey = process.env.NEXT_PUBLIC_BLOCKFROST_API_KEY || '';
      initLucid(blockfrostKey)
        .then(setLucid)
        .catch(console.error);
    }
  }, []);

  const connect = async (wallet: string) => {
    if (!lucid) throw new Error('Lucid not initialized');

    setIsConnecting(true);
    try {
      const { address } = await connectWallet(lucid, wallet);
      setAddress(address);
      setWalletName(wallet);

      // Persist to localStorage
      localStorage.setItem('connectedWallet', wallet);
    } catch (error) {
      console.error('Connection failed:', error);
      throw error;
    } finally {
      setIsConnecting(false);
    }
  };

  const disconnect = () => {
    setAddress(null);
    setWalletName(null);
    localStorage.removeItem('connectedWallet');
  };

  return (
    <WalletContext.Provider
      value={{ lucid, address, walletName, isConnecting, connect, disconnect }}
    >
      {children}
    </WalletContext.Provider>
  );
}

export const useWallet = () => {
  const context = useContext(WalletContext);
  if (!context) throw new Error('useWallet must be used within WalletProvider');
  return context;
};
```

### 5. Aiken Smart Contract Structure

**Directory Structure:**
```
contracts/
├── aiken.toml
├── lib/
│   ├── contract_name/
│   │   ├── types.ak
│   │   └── utils.ak
│   └── tests/
│       ├── test_success.ak
│       └── test_failure.ak
└── validators/
    └── contract_name.ak
```

**aiken.toml Configuration:**
```toml
name = "your-project/contract-name"
version = "0.1.0"
compiler = "v1.1.9"
plutus = "v3"
license = "Apache-2.0"
description = "Smart contract for [describe purpose]"

[repository]
user = "your-username"
project = "your-project"
platform = "github"

[[dependencies]]
name = "aiken-lang/stdlib"
version = "2.2.0"
source = "github"

[[dependencies]]
name = "aiken-lang/fuzz"
version = "2.1.0"
source = "github"
```

**Example Validator (Simple Lock/Unlock):**
```aiken
// validators/simple_lock.ak
use aiken/collection/list
use aiken/crypto.{VerificationKeyHash}
use cardano/transaction.{OutputReference, Transaction}

type Datum {
  owner: VerificationKeyHash,
  locked_until: Int,
}

type Redeemer {
  Unlock
}

validator simple_lock {
  spend(
    datum: Option<Datum>,
    redeemer: Redeemer,
    _input: OutputReference,
    transaction: Transaction,
  ) {
    expect Some(datum) = datum
    expect Unlock = redeemer

    let Transaction { validity_range, extra_signatories, .. } = transaction

    // Check: Owner must sign
    let signed_by_owner = list.has(extra_signatories, datum.owner)

    // Check: Current time must be past locked_until
    expect Some(lower_bound) = validity_range.lower_bound.bound_type
    let time_passed = lower_bound >= datum.locked_until

    signed_by_owner && time_passed
  }
}
```

### 6. Building and Exporting Aiken Contracts

```bash
# Build contracts
cd contracts
aiken build

# This generates plutus.json in the root with:
# - Compiled Plutus Core code
# - Blueprint schema
# - Parameter specifications
```

**Import compiled contract into Next.js:**
```typescript
// lib/contracts.ts
import blueprint from '@/plutus.json';

export function getValidator(name: string) {
  const validator = blueprint.validators.find(v => v.title === name);
  if (!validator) throw new Error(`Validator ${name} not found`);
  return validator;
}

export function getValidatorScript(name: string): string {
  const validator = getValidator(name);
  return validator.compiledCode;
}
```

### 7. Transaction Building with Lucid Evolution

```typescript
// lib/transactions/lock-funds.ts
'use client';

import { Lucid, Data, UTxO } from '@lucid-evolution/lucid';
import { getValidatorScript } from '@/lib/contracts';

// Define Datum schema matching Aiken contract
const DatumSchema = Data.Object({
  owner: Data.Bytes(),
  locked_until: Data.Integer(),
});
type DatumType = Data.Static<typeof DatumSchema>;

export async function lockFunds(
  lucid: Lucid,
  amount: bigint,
  lockedUntil: bigint
) {
  const validatorScript = getValidatorScript('simple_lock');
  const scriptAddress = lucid.utils.validatorToAddress({
    type: 'PlutusV3',
    script: validatorScript,
  });

  const ownerPubKeyHash = lucid.utils.getAddressDetails(
    await lucid.wallet().address()
  ).paymentCredential?.hash;

  if (!ownerPubKeyHash) throw new Error('Could not get owner public key hash');

  const datum = Data.to<DatumType>(
    {
      owner: ownerPubKeyHash,
      locked_until: lockedUntil,
    },
    DatumSchema
  );

  const tx = await lucid
    .newTx()
    .pay.ToAddressWithData(
      scriptAddress,
      { kind: 'inline', value: datum },
      { lovelace: amount }
    )
    .attach.Script({
      type: 'PlutusV3',
      script: validatorScript,
    })
    .complete();

  const signedTx = await tx.sign.withWallet().complete();
  const txHash = await signedTx.submit();

  return txHash;
}

export async function unlockFunds(lucid: Lucid, utxo: UTxO) {
  const validatorScript = getValidatorScript('simple_lock');
  const redeemer = Data.to('Unlock');

  const currentTime = Date.now();

  const tx = await lucid
    .newTx()
    .collectFrom([utxo], redeemer)
    .attach.Script({
      type: 'PlutusV3',
      script: validatorScript,
    })
    .validFrom(currentTime)
    .complete();

  const signedTx = await tx.sign.withWallet().complete();
  const txHash = await signedTx.submit();

  return txHash;
}
```

### 8. Environment Variables

```env
# .env.local
NEXT_PUBLIC_BLOCKFROST_API_KEY=preview_your_api_key_here
NEXT_PUBLIC_CARDANO_NETWORK=Preview
NEXT_PUBLIC_EXPLORER_URL=https://preview.cardanoscan.io
```

### 9. TypeScript Configuration

```json
// tsconfig.json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules", "contracts"]
}
```

### 10. Wallet Connection Component

```typescript
// components/WalletSelector.tsx
'use client';

import { useState, useEffect } from 'react';
import { useWallet } from '@/contexts/WalletContext';
import { Button, Card, CardBody } from '@nextui-org/react';

const SUPPORTED_WALLETS = [
  { name: 'nami', displayName: 'Nami', icon: '🦊' },
  { name: 'eternl', displayName: 'Eternl', icon: '♾️' },
  { name: 'flint', displayName: 'Flint', icon: '🔥' },
  { name: 'yoroi', displayName: 'Yoroi', icon: '🎴' },
];

export function WalletSelector() {
  const { address, connect, disconnect, isConnecting } = useWallet();
  const [availableWallets, setAvailableWallets] = useState<string[]>([]);

  useEffect(() => {
    if (typeof window !== 'undefined') {
      const available = SUPPORTED_WALLETS
        .filter(w => window.cardano?.[w.name])
        .map(w => w.name);
      setAvailableWallets(available);
    }
  }, []);

  if (address) {
    return (
      <Card>
        <CardBody>
          <p className="text-sm">Connected: {address.slice(0, 20)}...</p>
          <Button color="danger" onClick={disconnect} className="mt-2">
            Disconnect
          </Button>
        </CardBody>
      </Card>
    );
  }

  return (
    <div className="grid grid-cols-2 gap-4">
      {SUPPORTED_WALLETS.map(wallet => (
        <Button
          key={wallet.name}
          onClick={() => connect(wallet.name)}
          isDisabled={
            !availableWallets.includes(wallet.name) || isConnecting
          }
          variant="bordered"
        >
          {wallet.icon} {wallet.displayName}
        </Button>
      ))}
    </div>
  );
}
```

---

## 🔐 Security Best Practices

1. **Never expose private keys**: Always use wallet APIs
2. **Validate all datums**: Check types match Aiken schemas
3. **Set transaction validity ranges**: Prevent replay attacks
4. **Test on testnet first**: Use Preview or Preprod networks
5. **Implement proper error handling**: User-friendly messages
6. **Add transaction confirmation UI**: Show pending/success states
7. **Use HTTPS for all API calls**: Especially Blockfrost/Koios

---

## 🧪 Testing Strategy

1. **Aiken Unit Tests**: Test validators with `aiken check -v`
2. **Integration Tests**: Test full transaction flow on testnet
3. **Wallet Connection**: Test with multiple wallets
4. **Edge Cases**: Test with insufficient funds, expired timelock, etc.

---

## 📚 Common Pitfalls & Solutions

### ❌ Problem: "parseVec could not cast the value" build error
✅ **Solution**:
- Use Next.js 15+ with Turbopack
- Externalize Lucid on server-side in webpack config
- Use 'use client' directive in all Lucid-importing files

### ❌ Problem: Wallet not detected
✅ **Solution**:
- Check `typeof window !== 'undefined'` before accessing
- Wait for wallet extension to load (add delay or detection)
- Provide clear install instructions for each wallet

### ❌ Problem: Transaction fails with "Script execution failed"
✅ **Solution**:
- Verify datum schema matches Aiken exactly (including field order)
- Check redeemer format
- Ensure all required signatures are present
- Verify validity range is set correctly

### ❌ Problem: "UTxO not found at script address"
✅ **Solution**:
- Query script address UTxOs before unlock
- Check network (Preview vs Preprod vs Mainnet)
- Wait for transaction confirmation before next action

---

## 🎨 UI/UX Recommendations

1. **Loading States**: Show spinners during transaction submission
2. **Toast Notifications**: Use react-toastify for success/error messages
3. **Transaction Links**: Link to Cardano explorer for submitted txs
4. **Wallet Balance Display**: Show ADA balance after connection
5. **Dark Mode**: Use next-themes for theme switching
6. **Responsive Design**: Mobile-first with Tailwind breakpoints

---

## 📝 Example Complete Flow

**User Story**: Lock 10 ADA for 1 hour, then unlock

1. User connects Nami wallet
2. User enters amount (10 ADA) and duration (1 hour)
3. App builds datum with current time + 1 hour
4. Transaction submitted to lock funds at script address
5. Toast shows "Transaction submitted" with explorer link
6. After 1 hour, user clicks "Unlock"
7. App queries UTxO at script address
8. Transaction built with redeemer and validity range
9. Funds returned to user's wallet

---

## 🚀 Deployment Checklist

- [ ] Test all transactions on Cardano Preview testnet
- [ ] Verify Aiken contracts with `aiken check`
- [ ] Build Next.js with `npm run build` (no errors)
- [ ] Set production environment variables
- [ ] Test wallet connections on deployed site
- [ ] Add analytics/monitoring (optional)
- [ ] Document API endpoints and contract interfaces
- [ ] Create user guide with screenshots

---

## 📖 Additional Resources

- **Lucid Evolution Docs**: https://anastasia-labs.github.io/lucid-evolution/
- **Aiken Documentation**: https://aiken-lang.org/
- **Cardano Developer Portal**: https://developers.cardano.org/
- **CIP-30 Wallet Standard**: https://cips.cardano.org/cip/CIP-30
- **Blockfrost API**: https://blockfrost.io/
- **Koios API**: https://koios.rest/

---

## 🎯 Final Notes for AI Code Generation

When generating this app:

1. **Always use Next.js 15+** with Turbopack for best performance
2. **Client-side only for Lucid**: Mark all Lucid imports with 'use client'
3. **Match Aiken types exactly**: Data schema must align with .ak files
4. **Test incrementally**: Build → Test contract → Build UI → Test integration
5. **Provide helpful error messages**: Don't just throw, explain what went wrong
6. **Include comments**: Explain Cardano-specific concepts (UTxO, datum, redeemer)
7. **Use TypeScript strictly**: Catch errors at compile time
8. **Follow Next.js App Router conventions**: Use app/ directory structure

---

## 💡 Example Prompt to Use This Template

```
Create a Cardano crowdfunding dApp using Next.js 15, Lucid Evolution, and Aiken following these specifications:

[Paste relevant sections from this document]

Features:
- Campaign creator can create campaign with goal and deadline
- Backers can contribute ADA to campaigns
- Creator can collect funds if goal is reached before deadline
- Backers can get refunds if campaign fails

Include:
- Full Aiken smart contract with validators
- Next.js frontend with wallet connection
- Transaction building for all operations
- Proper error handling and user feedback
- Dark mode with NextUI components

Follow all configuration requirements exactly to avoid WebAssembly build errors.
```
