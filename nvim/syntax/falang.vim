" Vim syntax file
" Language: falang
" Maintainer: MIA
" Latest Revision: 30 mai 2019

if exists("b:current_syntax")
  finish
endif

" Integer with - + or nothing in front
syn match celNumber '\d\+'
syn match celNumber '0x\x\+'

syn keyword celBlockCmd  accessibility_service  cert  certificate  class  device_admin  dex  features  file  frosting  icon  lib  libs  limits  manif  manifest  method  random  sig  signature  super  xml  zip 
syn keyword celBlockCmd  CERT_COMPLETENESS  CERT_CONTAINS_CLEAN_KEYWORDS  CERT_IS_TESTKEY_DEBUG  CERT_NUMBER_OF_FIELD_REPETITIONS  CERT_RANDOMNESS  CODE_ABSTRACT_METHODS_RATIO  CODE_APP_ENTRY_POINT_CONSTRUCTOR_SIZE  CODE_AVERAGE_INHERITANCE_CHAIN  CODE_CLASSES_NAMES_LENGTH_RATIO  CODE_CLASS_COUNT  CODE_EP_REFLECTION_CALLS  CODE_EP_REFLECTION_CLASSES  CODE_LONGEST_INHERITANCE_CHAIN  CODE_METHODS_2KB  CODE_METHOD_CALLS  CODE_METHOD_COUNT  CODE_METHOD_NAMES_LENGTH_RATIO  CODE_NATIVE_METHODS_RATIO  CODE_NB_ANON_INTERN_CLASSES  CODE_NB_INTERN_CLASSES_RATIO  CODE_NB_PACKAGES  CODE_REFLECTION_CALLS  CODE_REFLECTION_CLASSES  FILES_ABC  FILES_ASSETS_RATIO_COMPRESSED  FILES_COMMON  FILES_COMPRESSED_MANIFEST_KB  FILES_COM_FACEBOOK  FILES_DEX_APK_RATIO  FILES_DEX_COUNT  FILES_EXT_IMAGE  FILES_EXT_SO  FILES_GOOGLE  FILES_HAS_STORED_SIZE_EXPLOIT  FILES_IC  FILES_NR_DIRS_IN_ASSETS_FOLDER  FILES_NR_DIRS_IN_ZIP  FILES_NR_FILES_IN_RES_FOLDER  FILES_NR_FILES_IN_ZIP  FILES_NR_FILES_WITHOUT_EXTENSION  FILES_NR_SUPPORTED_ARCH  FILES_NR_UNUSUAL_ROOT_FILES  MANIFEST_BOOT_COMPLETED_RAN  MANIFEST_BROWSABLE_CTN  MANIFEST_CATEGORY_PRESENCE  MANIFEST_COMPONENTS_UNDER_PKG_RATION  MANIFEST_EPS_STR_LETTER_COUNT  MANIFEST_EPS_STR_NR_COUNT  MANIFEST_HAS_APPLICATION_ENTRY_POINT  MANIFEST_META_TAGS_COUNT  MANIFEST_MIN_SDK_VERSION  MANIFEST_PKG_COMPONENTS_COUNT  MANIFEST_RESOURCE_COUNT  MANIFEST_REXPORTED_PRESENCE  MANIFEST_SCREEN_ORIENTATION_TRJ_PROB  MANIFEST_SEND_ACN  MANIFEST_TARGET_SDK_VERSION  MANIFEST_USES_CLEARTEXT_TRAFFIC  MANIFEST_VIEW_ACN  MANIFEST_VN_LEN  META_APK_SIZE_100KB  META_CJK_DEX  META_CJK_RES  META_CYR_DEX  META_CYR_RES  activities  acts  all  code  components  content  dir  dist  fullname  hash  name  packagename  path  permissions  perms  pkg  policies  pros  providers  receivers  recs  sers  services  sha1  state  telfhash  trig  vcode 
syn keyword celBlockCmd count not
syn keyword celBlockCmd trig name 

syn keyword celBoolConst true false 
syn keyword celOtherConst inf

syn region celString start='"' end='"'
syn match celComment "#.*$"
syn match celComment "//.*$"
syn region celComment start='/\*' end='\*/'

" hi def link celTodo        Todo
hi def link celComment     Comment
hi def link celBlockCmd    Statement
" hi def link celHip         Type
hi def link celString      String

hi def link celNumber      Number
hi def link celBoolConst      Boolean
hi def link celOtherConst      Constant



