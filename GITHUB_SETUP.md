# Push to GitHub - Complete Guide

## ✅ What's Done
- Git repository initialized
- All files committed (109 files, 33,675 lines)
- Branch renamed to 'main'
- Commit message created

## 🚀 Next Steps to Push to Your GitHub

### Option 1: Create a New Repository on GitHub (Recommended)

#### Step 1: Create Repository on GitHub
1. Go to https://github.com/MiroslavRet
2. Click the **"+"** button (top right) → **"New repository"**
3. Repository name: `cardano-dapp-template` (or your choice)
4. Description: "Production-ready Cardano dApp template with Aiken, Lucid Evolution, and Next.js"
5. Choose **Public** or **Private**
6. **DO NOT** check "Initialize with README" (we already have files)
7. Click **"Create repository"**

#### Step 2: Push to GitHub
After creating the repository, run these commands:

```bash
# Add GitHub as remote
git remote add origin https://github.com/MiroslavRet/cardano-dapp-template.git

# Push to GitHub
git push -u origin main
```

If you have 2FA enabled or prefer SSH:
```bash
# Using SSH (if you have SSH key set up)
git remote add origin git@github.com:MiroslavRet/cardano-dapp-template.git
git push -u origin main
```

### Option 2: Push to Existing Repository

If you already have a repository:

```bash
# Add your existing repo as remote
git remote add origin https://github.com/MiroslavRet/YOUR-REPO-NAME.git

# Push to main branch
git push -u origin main
```

## 📝 Authentication

### If Prompted for Credentials:
- **Username**: MiroslavRet
- **Password**: Use a Personal Access Token (NOT your GitHub password)

### Generate Personal Access Token:
1. Go to https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Select scopes: **repo** (full control)
4. Click **"Generate token"**
5. Copy the token (you won't see it again!)
6. Use this token as your password when pushing

## 🔍 Verify After Push

After pushing, visit:
```
https://github.com/MiroslavRet/cardano-dapp-template
```

You should see:
- ✅ All files and folders
- ✅ README.md displayed on homepage
- ✅ Documentation files
- ✅ Smart contracts in `lib/` and `validators/`
- ✅ Frontend code in `offchain/`

## 📋 What's Included (109 Files)

### Smart Contracts (Aiken)
- `lib/crowdfunding.ak` - Core validation logic
- `lib/crowdfunding/types.ak` - Type definitions
- `lib/crowdfunding/utils.ak` - Utility functions
- `validators/crowdfunding_b.ak` - Main validator
- `lib/tests/` - Test files
- `plutus.json` - Compiled contracts

### Frontend (Next.js)
- `offchain/app/` - All pages (admin, backer, creator, hacker)
- `offchain/components/` - React components
- `offchain/config/` - Configuration files
- `offchain/types/` - TypeScript types

### Documentation
- `README.md` - Main documentation
- `TEMPLATE_README.md` - Complete usage guide
- `TEMPLATE_SUMMARY.md` - Quick overview
- `BOLT_NEW_USAGE.md` - Bolt.new integration guide
- `QUICK_REFERENCE.md` - Developer reference
- `CARDANO_DAPP_GENERATION_GUIDE.md` - Technical specs
- `WHERE_IS_TEMPLATE.md` - Template location guide
- `GITHUB_SETUP.md` - This file

### Configuration
- `aiken.toml` - Aiken project configuration
- `offchain/package.json` - Dependencies
- `offchain/next.config.js` - Next.js configuration
- `offchain/.env.example` - Environment variables template
- `.gitignore` - Git ignore rules

## 🎯 After Pushing to GitHub

### Update Template References

1. **Update WHERE_IS_TEMPLATE.md**:
   Replace `YOUR-USERNAME` with `MiroslavRet`

2. **Update Supabase Documentation**:
   ```sql
   UPDATE cardano_templates
   SET repository_url = 'https://github.com/MiroslavRet/cardano-dapp-template'
   WHERE id = 'f25cc7ce-daff-4830-bcce-88efd9529e56';
   ```

3. **Share the Template**:
   Your template is now at:
   ```
   https://github.com/MiroslavRet/cardano-dapp-template
   ```

### Using in Bolt.new (After Push)

In a new Bolt.new session:
```
Create a new Cardano dApp based on the template at:
https://github.com/MiroslavRet/cardano-dapp-template

Customize it for [YOUR USE CASE].
```

## 🔧 Quick Command Reference

```bash
# Check current status
git status

# View commit history
git log --oneline

# Add more changes later
git add .
git commit -m "Your commit message"
git push

# View remote URL
git remote -v

# Change remote URL if needed
git remote set-url origin https://github.com/MiroslavRet/new-repo.git
```

## 🆘 Troubleshooting

### "remote: Repository not found"
- Check repository name is correct
- Verify repository exists on GitHub
- Check you're logged in to correct GitHub account

### "Authentication failed"
- Use Personal Access Token (not password)
- Generate token at: https://github.com/settings/tokens
- Token needs 'repo' scope

### "rejected: non-fast-forward"
- This is a new repo, shouldn't happen
- If it does: check you didn't initialize with README

### "Permission denied (publickey)"
- If using SSH: add your SSH key to GitHub
- Settings → SSH and GPG keys
- Or use HTTPS instead

## 📚 Additional Resources

- [GitHub Docs - Creating a Repo](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [GitHub Docs - Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Git Documentation](https://git-scm.com/doc)

## ✅ Success Checklist

- [ ] GitHub repository created
- [ ] Remote added to local git
- [ ] Code pushed to GitHub
- [ ] Repository visible on GitHub
- [ ] README displays correctly
- [ ] Updated WHERE_IS_TEMPLATE.md with actual URL
- [ ] Updated Supabase with GitHub URL
- [ ] Tested cloning from GitHub

---

**Ready to push?** Follow Option 1 above to create a new repository and push your template!
