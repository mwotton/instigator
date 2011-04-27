module Paths_cabalconsole (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName
  ) where

import Data.Version (Version(..))
import System.Environment (getEnv)

version :: Version
version = Version {versionBranch = [0,1], versionTags = []}

bindir, libdir, datadir, libexecdir :: FilePath

bindir     = "/home/mwotton/.cabal/bin"
libdir     = "/home/mwotton/.cabal/lib/cabalconsole-0.1/ghc-6.12.1"
datadir    = "/home/mwotton/.cabal/share/cabalconsole-0.1"
libexecdir = "/home/mwotton/.cabal/libexec"

getBinDir, getLibDir, getDataDir, getLibexecDir :: IO FilePath
getBinDir = catch (getEnv "cabalconsole_bindir") (\_ -> return bindir)
getLibDir = catch (getEnv "cabalconsole_libdir") (\_ -> return libdir)
getDataDir = catch (getEnv "cabalconsole_datadir") (\_ -> return datadir)
getLibexecDir = catch (getEnv "cabalconsole_libexecdir") (\_ -> return libexecdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
