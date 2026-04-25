if exists("b:current_syntax")
  finish
endif

syn case match
syn sync minlines=200

" Load Markdown first
runtime! syntax/markdown.vim

" Reuse the real runtime syntaxes as clusters
syntax include @ReviewGit  syntax/git.vim
syntax include @ReviewMail syntax/mail.vim
syntax include @ReviewDiff syntax/diff.vim

" --------------------------------------------------
" Optional fenced blocks (strong highlighting inside)
" --------------------------------------------------
syntax region reviewDiffBlock
      \ start="^\s*```diff\s*$"
      \ end="^\s*```\s*$"
      \ contains=@ReviewDiff,@ReviewGit,@ReviewMail
      \ keepend

syntax region reviewGitBlock
      \ start="^\s*```git\s*$"
      \ end="^\s*```\s*$"
      \ contains=@ReviewGit,@ReviewDiff
      \ keepend

syntax region reviewMailBlock
      \ start="^\s*```mail\s*$"
      \ end="^\s*```\s*$"
      \ contains=@ReviewMail
      \ keepend

" --------------------------------------------------
" Git / Diff structure (outside code blocks too)
" --------------------------------------------------
syntax match reviewGitDiff   "^diff --git .*"
syntax match reviewGitIndex  "^index \x\{7,40}\.\.\x\{7,40}"
syntax match reviewGitHunk   "^@@ .* @@"

syntax match reviewGitOld    "^--- .*"
syntax match reviewGitNew    "^+++ .*"

syntax match reviewGitRename "^rename \(from\|to\) .*"
syntax match reviewGitMode   "^\(new file mode\|deleted file mode\|old mode\|new mode\) .*"
syntax match reviewGitBinary "^Binary files .* differ"

syntax match reviewCommit    "^commit \x\{7,40}"
syntax match reviewMerge     "^Merge: .*"
syntax match reviewBranch    "^\%(HEAD ->\|origin/\)\S\+"

syntax match reviewAuthor    "^Author: .*"
syntax match reviewCommitter "^Commit: .*"
syntax match reviewDate      "^Date: .*"

syntax match reviewHash      "\<\x\{7,40}\>"

" --------------------------------------------------
" Diff lines
" --------------------------------------------------
syntax match reviewDiffAdd "^+\S.*" containedin=ALL
syntax match reviewDiffDel "^-\\S.*" containedin=ALL
syntax match reviewDiffChange "^!.*" containedin=ALL

" --------------------------------------------------
" Mail headers and mail-like content
" --------------------------------------------------
syntax match reviewMailHeader "^\%(From \|Subject:\|To:\|Cc:\|Date:\|Reply-To:\).*"
syntax match reviewMailID     "^Message-Id: .*"
syntax match reviewMailReply  "^In-Reply-To: .*"

" Only deep quotes, so Markdown blockquotes stay mostly intact
syntax match reviewMailQuote "^>\{2,} .*"

" Optional mail signature line
syntax match reviewMailSignature "^--\s$"

" --------------------------------------------------
" Sections / tags for your custom review format
" --------------------------------------------------
syntax match reviewSection "^##\+ .*"
syntax match reviewTag "\[\%(PATCH\|RFC\|WIP\)\]"

" --------------------------------------------------
" Highlight links
" --------------------------------------------------
hi def link reviewGitDiff     Statement
hi def link reviewGitIndex    Identifier
hi def link reviewGitHunk     PreProc

hi def link reviewGitOld      DiffDelete
hi def link reviewGitNew      DiffAdd
hi def link reviewGitRename   Type
hi def link reviewGitMode     Type
hi def link reviewGitBinary   Comment

hi def link reviewDiffAdd     DiffAdd
hi def link reviewDiffDel     DiffDelete
hi def link reviewDiffChange  DiffChange

hi def link reviewCommit      Keyword
hi def link reviewMerge       Keyword
hi def link reviewBranch      Identifier

hi def link reviewAuthor      String
hi def link reviewCommitter   String
hi def link reviewDate        Number
hi def link reviewHash        Identifier

hi def link reviewMailHeader   Title
hi def link reviewMailID       Special
hi def link reviewMailReply    Special
hi def link reviewMailQuote    Comment
hi def link reviewMailSignature Comment

hi def link reviewSection      Title
hi def link reviewTag          Special

let b:current_syntax = "review"
