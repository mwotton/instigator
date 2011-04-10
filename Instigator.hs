{-# LANGUAGE ScopedTypeVariables #-}
module Instigator where

import Network.Curl
import Network.Curl.Easy
import Text.Regex.Posix

--instance Show CurlResponse where
--    show CurlResponse a b = Prelude.show (a,b)


printC (CurlResponse a b c d e f) = print (a,b,c,d,e)


newRepo name = withCurlDo $ do
                 curl  <- initialize
                 add_repo curl name
                 add_hook curl name

add_repo curl name = do
  res <- do_curl curl "https://github.com/api/v2/json/repos/create" 
         [CurlPostFields ["name="++name]
         ,CurlUserPwd "mwotton/token:d5928451e565509088b5429940ea5b84"    
         ]
  printC res

add_hook curl name = do
         -- add a post-commit hook
  res <- do_curl curl ("https://github.com/login") []
  let html = (respBody res :: String)
  -- out come the hax


  let (_,_,_,authtoken)  = (html =~ ".*auth_token = \"([a-z0-9]*).*") :: (String,String,String,[String])
  print authtoken
  res2 <- do_curl curl ("https://github.com/mwotton/" ++ name ++ "/admin/postreceive_urls")
          [CurlPostFields ["urls%5%D=http://mycleverurl.example.com/",
                           "login=mwotton",
                           "token=d5928451e565509088b5429940ea5b84"
                          ]
          ,CurlFollowLocation True
          ]
  --printC res2
  print "done"
