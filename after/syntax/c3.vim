if exists("b:current_syntax")
  finish
endif

syntax case match

" Core language words
syn keyword c3Keyword module import using alias as fn return if else elseif for while break continue switch case default defer try catch fault assert const var static pub private struct union enum typedef bitstruct sizeof typeof typeid true false null

" Built-in/basic types from the official language docs
syn keyword c3Type any bfloat bool char double fault float float16 float128 ichar int int128 iptr isz long short uint uint128 ulong uptr ushort usz void

syn keyword c3StorageClass extern inline
syn keyword c3Todo contained TODO FIXME XXX NOTE HACK

" Function declarations: fn return_type name(...)
syn match c3Function /\v\<fn\s+\zs[a-z_][A-Za-z0-9_]*\ze\s*\(/

" PascalCase type names
syn match c3TypeName /\v\<[A-Z][A-Za-z0-9_]*\>/

" All-caps constants
syn match c3Constant /\v\<[A-Z][A-Z0-9_]*\>/

" Compile-time and builtin-style sigils
syn match c3BuiltinSigil /\v[$@][A-Za-z_][A-Za-z0-9_]*\>/

" Numbers
syn match c3Number /\v%(^|[^[:alnum:]_])\zs(0[xX][0-9A-Fa-f_]+|0[bB][01_]+|\d[\d_]*(\.\d[\d_]*)?([eE][+-]?\d[\d_]*)?)([uUlLfF]{0,3})?/

" Strings, raw strings, chars
syn region c3String start=+"+ skip=+\\.+ end=+"+ contains=c3Escape
syn region c3RawString start=+`+ end=+`+ contains=@Spell
syn match c3Char /'\(\\.\|[^\\']\)'/
syn match c3Escape /\\[abfnrtv\\'"?0-7xuU]/ contained

" Comments
syn match c3LineComment "//.*$"
syn region c3BlockComment start="/\*" end="\*/" contains=c3Todo,c3LineComment

" Links to standard highlight groups, so your theme does the coloring
hi def link c3Keyword Keyword
hi def link c3Type Type
hi def link c3StorageClass StorageClass
hi def link c3Function Function
hi def link c3TypeName Type
hi def link c3Constant Constant
hi def link c3BuiltinSigil PreProc
hi def link c3Number Number
hi def link c3String String
hi def link c3RawString String
hi def link c3Char Character
hi def link c3Escape SpecialChar
hi def link c3LineComment Comment
hi def link c3BlockComment Comment
hi def link c3Todo Todo

let b:current_syntax = "c3"
