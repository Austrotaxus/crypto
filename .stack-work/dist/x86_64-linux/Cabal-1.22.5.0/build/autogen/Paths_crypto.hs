module Paths_crypto (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/austrotaxus/crypto/.stack-work/install/x86_64-linux/lts-6.10/7.10.3/bin"
libdir     = "/home/austrotaxus/crypto/.stack-work/install/x86_64-linux/lts-6.10/7.10.3/lib/x86_64-linux-ghc-7.10.3/crypto-0.1.0.0-9HSOuTb2mfa3j5HpkxhfyV"
datadir    = "/home/austrotaxus/crypto/.stack-work/install/x86_64-linux/lts-6.10/7.10.3/share/x86_64-linux-ghc-7.10.3/crypto-0.1.0.0"
libexecdir = "/home/austrotaxus/crypto/.stack-work/install/x86_64-linux/lts-6.10/7.10.3/libexec"
sysconfdir = "/home/austrotaxus/crypto/.stack-work/install/x86_64-linux/lts-6.10/7.10.3/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "crypto_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "crypto_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "crypto_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "crypto_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "crypto_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
