;; test_helpers.nu
;;  tests for NuHTTPHelpers.
;;
;;  Copyright (c) 2009 Tim Burks, Neon Design Technology, Inc.

(load "NuHTTPHelpers")

(class TestHelpers is NuTestCase
     
     (- testURLEncoding is
        
        (assert_equal "http%3A%2F%2Fprogramming.nu" ("http://programming.nu" urlEncode))
        (assert_equal "http%3A%2F%2Fprogramming.nu%2Fhome%3Fone%3D1%26two%3D2%263%3Dthree" ("http://programming.nu/home?one=1&two=2&3=three" urlEncode))
        (assert_equal "one+two+three%2C+four+five+six" ("one two three, four five six" urlEncode))
        (assert_equal "caf%E9" ("caf\xe9" urlEncode)))
     
     (- testURLDecoding is
        (assert_equal "http://programming.nu" ("http%3A%2F%2Fprogramming.nu" urlDecode))
        (assert_equal "http://programming.nu/home?one=1&two=2&3=three" ("http%3A%2F%2Fprogramming.nu%2Fhome%3Fone%3D1%26two%3D2%263%3Dthree" urlDecode))
        (assert_equal "one two three, four five six" ("one+two+three%2C+four+five+six" urlDecode))
        (assert_equal "caf\xe9" ("caf%E9" urlDecode)))
     
     (- testURLQueryDictionaryEncoding is
        (set d (dict one:1 two:2 zero:"z,e r&o"))
        (set s "one=1&two=2&zero=z%2Ce+r%26o")
        (assert_equal s (d urlQueryString))
        (assert_equal (d description) ((s urlQueryDictionary) description)))
     
     (- testBase64 is
        (set d (NSData dataWithContentsOfFile:"objc/NuHTTPHelpers.m"))
        (assert_equal (d base64) (((d base64) dataUsingBase64Encoding) base64))
        (assert_equal d  ((d base64) dataUsingBase64Encoding)))
     
     (- testHashFunctions is
        (set thirtyTwoZeros (NSData dataWithSize:32))
        ;; ok, it's really 64. Two zeros per byte.
        (assert_equal "0000000000000000000000000000000000000000000000000000000000000000" (thirtyTwoZeros hex))
        ;;
        ;; MD5 hashing
        ;;
        ;; golden result obtained with "openssl md5"
        (assert_equal "70bc8f4b72a86921468bf8e8441dce51" ((thirtyTwoZeros md5) hex))
        ;; golden result obtained with "openssl md5 | openssl base64"
        (assert_equal "cLyPS3KoaSFGi/joRB3OUQ==" ((thirtyTwoZeros md5) base64))
        ;;
        ;; HMAC-SHA1 hashing
        ;;
        ;; golden result obtained with "openssl sha1 -hmac secret"
        (assert_equal "1cd0e4db152978b086c3fbd1d88b3d0fbc75b9d0" ((thirtyTwoZeros hmac_sha1:("secret" dataUsingEncoding:NSUTF8StringEncoding)) hex))
        ;; golden result obtained with "openssl sha1 -hmac secret -binary | openssl base64"
        (assert_equal "HNDk2xUpeLCGw/vR2Is9D7x1udA=" ((thirtyTwoZeros hmac_sha1:("secret" dataUsingEncoding:NSUTF8StringEncoding)) base64))
        ;;
        ;; Salted MD5 hashing, typically used for passwords
        ;;
        ;; golden result obtained with "openssl passwd -1 -salt sauce"
        (assert_equal "$1$sauce$ToKwxvX1ZyeiswSSzdPRi0" ("secret" md5HashWithSalt:"sauce"))))

