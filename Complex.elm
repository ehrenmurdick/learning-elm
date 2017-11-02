module Complex exposing (..)


type alias Complex =
    { realPart : Int, imagPart : Int }


(:+) : Int -> Int -> Complex
(:+) r i =
    complex r i


complex r i =
    Complex r i


mult : Complex -> Complex -> Complex
mult aa bb =
    let
        a =
            aa.realPart

        b =
            aa.imagPart

        c =
            bb.realPart

        d =
            bb.imagPart
    in
        (a * c - d * b) :+ (a * d + b * c)


square : Complex -> Complex
square a =
    mult a a


sqMag : Complex -> Int
sqMag a =
    (a.realPart * a.realPart) + (a.imagPart * a.imagPart)
