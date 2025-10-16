# Where Is The Cardano dApp Template?

## Current Location

Right now, the template is stored in **THREE places**:

### 1. Your Current Workspace (Temporary)
**Location**: `/tmp/cc-agent/58729820/project`

This is where you're working now in Bolt.new. All files are here:
- ✅ Complete Aiken smart contracts
- ✅ Next.js frontend application
- ✅ All documentation files
- ✅ Configuration files
- ✅ Compiled contracts (plutus.json)

**⚠️ Important**: This location is temporary and will be cleared when the session ends.

### 2. Supabase Database (Permanent Reference)
**Database**: Your Supabase instance at `uvopkbyuwafnmojmmrgr.supabase.co`

I've stored the template documentation in your Supabase database:
- ✅ Template metadata (name, version, description)
- ✅ Quick reference documentation
- ✅ Bolt.new usage guide
- ✅ Summary documentation

**Template ID**: `f25cc7ce-daff-4830-bcce-88efd9529e56`

**How to access**:
```sql
-- Get template info
SELECT * FROM cardano_templates;

-- Get all documentation
SELECT doc_type, title, file_path
FROM template_documentation
WHERE template_id = 'f25cc7ce-daff-4830-bcce-88efd9529e56';

-- Get specific documentation
SELECT content
FROM template_documentation
WHERE template_id = 'f25cc7ce-daff-4830-bcce-88efd9529e56'
AND doc_type = 'QUICK_REFERENCE';
```

### 3. Your Git Repository (Recommended - To Do)
**Status**: ⚠️ Not yet committed

You should commit this entire project to GitHub to preserve it permanently:

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Commit
git commit -m "Add production-ready Cardano dApp template v1.0.0"

# Push to GitHub
git remote add origin https://github.com/YOUR-USERNAME/cardano-dapp-template.git
git push -u origin main
```

---

## How to Use This Template in Bolt.new

Since you're already in Bolt.new with the template loaded, here's what happens:

### If You're Working Now (Template Already Loaded)
✅ **You already have access!** All files are in your current workspace.

Just start customizing:
```
Convert this Cardano crowdfunding template into a [YOUR USE CASE].
Keep the same technical stack and security patterns.

Examples:
- NFT marketplace
- Token vesting platform
- DAO voting system
```

### If You Start a New Bolt.new Session
You have two options:

#### Option A: Use GitHub (After You Push)
1. Push this project to GitHub (see above)
2. In Bolt.new, provide the GitHub URL
3. Bolt.new will clone the entire template
4. Start customizing

#### Option B: Use Supabase Documentation
1. Create a new Bolt.new project
2. Tell Bolt.new to query the template from Supabase:
```
Create a Cardano dApp based on the template stored in Supabase.
Template ID: f25cc7ce-daff-4830-bcce-88efd9529e56

Query the template documentation from:
- Database: uvopkbyuwafnmojmmrgr.supabase.co
- Table: cardano_templates and template_documentation

Use the stored patterns and documentation to recreate the full template.
```

---

## What's In Each Location?

### Current Workspace (Full Template)
```
cardano-dapp-template/
├── lib/                    # ✅ Aiken smart contracts
├── validators/             # ✅ Validator entry points
├── plutus.json            # ✅ Compiled contracts
├── offchain/              # ✅ Complete Next.js app
│   ├── app/              # ✅ All pages
│   ├── components/       # ✅ All components
│   ├── config/           # ✅ Configuration
│   └── types/            # ✅ TypeScript types
├── README.md              # ✅ Main documentation
├── TEMPLATE_README.md     # ✅ Complete guide
├── TEMPLATE_SUMMARY.md    # ✅ Quick overview
├── BOLT_NEW_USAGE.md      # ✅ Bolt.new guide
├── QUICK_REFERENCE.md     # ✅ Developer reference
└── CARDANO_DAPP_GENERATION_GUIDE.md  # ✅ Technical specs
```

### Supabase (Documentation Reference)
```
Tables:
- cardano_templates        # Template metadata
- template_documentation   # Documentation files

Stored:
- ✅ Template description
- ✅ Quick reference
- ✅ Bolt.new usage guide
- ✅ Summary documentation
```

### GitHub (After You Push)
```
Will contain:
- ✅ Complete source code
- ✅ All documentation
- ✅ Git history
- ✅ Public/private access control
- ✅ Version control
- ✅ Easy cloning and sharing
```

---

## Recommended Next Steps

### 1. **Commit to GitHub Now** (Recommended)
This preserves everything permanently:
```bash
git add .
git commit -m "Add Cardano dApp template v1.0.0"
git push origin main
```

### 2. **Continue Working** (If customizing now)
You already have everything loaded, just start coding:
```
Modify this crowdfunding template to create [YOUR APP].
```

### 3. **Export for Backup** (Optional)
If you can't push to GitHub right now:
- Download the entire project as ZIP
- Store locally or in cloud storage
- Push to GitHub later

---

## Quick Access Commands

### View Template in Supabase
```sql
-- Get template info
SELECT * FROM cardano_templates
WHERE id = 'f25cc7ce-daff-4830-bcce-88efd9529e56';

-- List all documentation
SELECT doc_type, title FROM template_documentation
WHERE template_id = 'f25cc7ce-daff-4830-bcce-88efd9529e56';

-- Read specific doc
SELECT content FROM template_documentation
WHERE template_id = 'f25cc7ce-daff-4830-bcce-88efd9529e56'
AND doc_type = 'QUICK_REFERENCE';
```

### Clone from GitHub (After Push)
```bash
git clone https://github.com/YOUR-USERNAME/cardano-dapp-template.git
cd cardano-dapp-template
cd offchain && npm install
npm run aiken:build
npm run dev
```

---

## When You Use This Template Next Time

### In Bolt.new:
```
I want to create a new Cardano dApp.

Please use the Cardano dApp template from:
- GitHub: https://github.com/YOUR-USERNAME/cardano-dapp-template
OR
- Supabase template_id: f25cc7ce-daff-4830-bcce-88efd9529e56

Clone the entire template and customize it for [YOUR USE CASE].
```

### Locally:
```bash
# Clone the template
git clone https://github.com/YOUR-USERNAME/cardano-dapp-template.git my-new-dapp

# Set up
cd my-new-dapp/offchain
npm install

# Build contracts
npm run aiken:build

# Start developing
npm run dev
```

---

## Summary

**Right Now**:
- ✅ Template is loaded in your Bolt.new workspace
- ✅ Documentation saved to Supabase
- ⚠️ Not yet in GitHub (you should do this)

**To Preserve Forever**:
1. Push to GitHub (recommended)
2. Or keep in Supabase (documentation only)
3. Or download as backup

**To Use in Future**:
1. Clone from GitHub, or
2. Tell Bolt.new to fetch from Supabase, or
3. Start from your downloaded backup

---

## Need Help?

See these files in your current workspace:
- **README.md** - Main documentation with quick navigation
- **TEMPLATE_SUMMARY.md** - Quick overview
- **TEMPLATE_README.md** - Complete usage guide
- **BOLT_NEW_USAGE.md** - Bolt.new specific instructions
- **QUICK_REFERENCE.md** - Developer quick reference
