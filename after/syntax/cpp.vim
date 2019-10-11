syntax keyword cppPrimitiveType float int bool char auto
syntax keyword cppConst const
syntax match cppOperator "\v\+|\-|\*|\/|\*|\=|\>|\<|\^|\||\&|\!|\."
syntax match cppPointerVar "\v(\w+)\*"
syntax match cppCommentOneLine "\v\/\/.+"

syntax keyword cppPolymorphism virtual override

syntax match CppFunction "\v(\w+)\(" contains=CppFunction1,CppFunction2
syntax match CppFunction1 "\v\("
syntax match CppFunction2 "\v\)"

syntax match Namespace "\v\w+\:\:" contains=Namespace1
syntax match Namespace1 "\v\:\:" contained

highlight link CppFunction Function
highlight link Namespace Type

highlight cppPrimitiveType ctermfg=116 guifg=#87dfdf
highlight cppConst ctermfg=81 guifg=#80a0ff
highlight cppPolymorphism ctermfg=227 guifg=#ffff5f
highlight cppOperator ctermfg=98 guifg=#875fd7
highlight cppPointerVar links to cppPolymorphism