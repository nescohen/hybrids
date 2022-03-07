module Language.Hybrids.Examples where

import Data.BitString
import System.IO
import System.Exit
import Language.Hybrids.AST

callOtp :: BitWidth -> Int -> IO ()
callOtp size n = call "EAVESDROP" [("m", n, size)] (otpReal size)

otpReal :: BitWidth -> Library
otpReal size =
    Lib "otp-real" (Block [Rout Nothing "EAVESDROP" (HSig ["m"])
        (
            Gets size (HVar "k")
            :> Assign (HVar "c") (Xor (Variable $ HVar "k") (Variable $ HVar "m"))
            :> Return (Variable $ HVar "c")
        )
    ]) Nothing

otpRand :: BitWidth -> Library 
otpRand size = 
    Lib "otp-rand" (Block [Rout Nothing "EAVESDROP" (HSig ["m"])
        (
            Gets size (HVar "c")
            :> Return (Variable $ HVar "c")
        )
    ]) Nothing

loopEx :: BitWidth -> Library 
loopEx (BitWidth n) = 
    Lib "loop-ex" (Block [Rout Nothing "CTXT" (HSig ["m"])
        (
            Loop (Bound $ Right $ HVar "i") (Bound (Left n)) (
                Gets (BitWidth n) (HVar "c_i")
            )
            :> Return (Variable $ HVar "c")
        )
    ]) Nothing