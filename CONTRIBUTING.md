# Contributing to nvim-config

Thank you for considering contributing!
Whether it's fixing bugs, adding features, improving documentation, or sharing suggestions, your contribution is welcome.

---

## Guidelines for Pull Requests (PRs)

To keep the repository clean and maintainable:

1. **Clean commits**: Ensure your commits are well-structured and follow conventional commit style.
2. **Branching**: Always create a new branch for each PR.

For example:-

```bash
git checkout -b feature/my-feature
```

3. **Single commit PRs**: Each PR should ideally contain a single commit. If you have multiple commits, squash them before creating the PR:

```bash
git rebase -i <branch_name>
```


4. **Descriptive messages**: Use clear commit messages explaining what the change does and why.


5. **Test before PR**: Make sure your changes don’t break existing functionality. Open Neovim and test thoroughly.

---

## ISSUES

If you encounter a problem or have a suggestion:

1. Check health first: Run `:checkhealth` in Neovim to ensure your setup is okay.


2. Verify upstream sources: Some issues may come from plugins or Neovim itself, not from this configuration. If so, report to the plugin or Neovim issue tracker.


3. Provide context: Include:

- Neovim version (`nvim --version`)

- Relevant plugin versions

- Minimal steps to reproduce

- Any error messages or screenshots

4. Keep it clear: Describe your concisely, so maintainers can understand and address it faster.

---

## SUGGESTIONS

If you want to suggest a new feature, enhancement, or plugin:

- **Feature Description**: What you want to add or improve.

- **Reason / Benefit**: Why it would help the configuration or other users.

- **Implementation Ideas (optional)**: Any suggestions on how to implement it.


Example:

```md
Feature Description:
Add an LSP status line integration

Reason:
Currently, I cannot see LSP diagnostics in real-time on the status line

Implementation Ideas:
Use `feline.nvim` or `lualine.nvim` with LSP components
```

---

## Style & Best Practices

- Use consistent formatting and follow the existing code style.

- For any large changes, consider opening an issue first to discuss the idea.

---

## Friendly Reminders

Contributions are not just code! Documentation, tutorials, and tips are also valuable.

Be respectful and courteous when interacting with maintainers and other contributors.

Keep in mind that sometimes issues are not caused by this config, but by upstream plugins or Neovim itself. Always check before reporting.

---

Thank you for helping make this nvim-config better for everyone!
