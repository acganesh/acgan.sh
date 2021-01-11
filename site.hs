--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import qualified Data.Set    as S
import           Hakyll
import           Text.Pandoc.Options

import GHC.IO.Encoding

--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration {
    destinationDirectory = "public"
}

main :: IO ()
main = do
    -- adding "setLocaleEncoding" as per https://www.reddit.com/r/haskell/comments/43tmt8/commitbuffer_invalid_argument_invalid_character/
    setLocaleEncoding utf8
    hakyllWith config $ do
      match "images/*" $ do
          route   idRoute
          compile copyFileCompiler

      match "css/*" $ do
          route   idRoute
          compile compressCssCompiler

      match "et-book/*/*" $ do
          route   idRoute
          compile copyFileCompiler

      match (fromList ["about.md", "projects.md", "maxent.md"]) $ do
          route   $ setExtension "html"
          compile $ customPandocCompiler
              >>= loadAndApplyTemplate "templates/default.html" defaultContext
              >>= relativizeUrls

      match "posts/*" $ do
          route $ setExtension "html"
          compile $ customPandocCompiler
              >>= loadAndApplyTemplate "templates/post.html"    postCtx
              >>= loadAndApplyTemplate "templates/default.html" postCtx
              >>= relativizeUrls

      match "index.html" $ do
          route idRoute
          compile $ do
              posts <- recentFirst =<< loadAll "posts/*"
              let indexCtx =
                      listField "posts" postCtx (return posts) `mappend`
                      constField "title" "Home"                `mappend`
                      defaultContext

              getResourceBody
                  >>= applyAsTemplate indexCtx
                  >>= loadAndApplyTemplate "templates/default.html" indexCtx
                  >>= relativizeUrls

      match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

customPandocCompiler =
    let mathExtensions =
            extensionsFromList [Ext_tex_math_dollars,
                                Ext_tex_math_single_backslash,
                                Ext_latex_macros]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = defaultExtensions <> mathExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax ""
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions
