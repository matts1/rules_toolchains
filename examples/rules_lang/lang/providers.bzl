"""Providers for lang"""

visibility("public")

LangInfo = provider("LangInfo", fields = {
    "compiled": "(File) Compiled file",
    "transitive_deps": "(depset[File]) All dependencies required to link a binary out of this target",
})
