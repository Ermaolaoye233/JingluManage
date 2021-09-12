import json
from base64 import urlsafe_b64decode, urlsafe_b64encode
import hmac
import time

def b64encode(s: bytes) -> str: # Base64 encoding
    # Encode Input
    s_bin = urlsafe_b64encode(s)
    s_bin = s_bin.replace(b'=', b'') 
    # Return the encoded content in ASCII character set
    return s_bin.decode('ascii') 

def b64decode(s: str) -> bytes: # Base64 decoding
    # Encode Input
    s_bin = s.encode('ascii') 
    s_bin += b'=' * (4 - len(s_bin) % 4)
    # Return the content original ocntent
    return urlsafe_b64decode(s_bin)

# Secret for encrypting
_secret = b"el-psy-kongroo"

default_header = {"typ":"JWT","alg":"HS256"} # default header

def JWTgenerator(payload, header=default_header):
    global _secret
    # Header and Payload base 64 encode
    header_b64 = b64encode(json.dumps(header, separators=(',',":")).encode('ascii'))
    payload_b64 = b64encode(json.dumps(payload, separators=(",",":")).encode('utf-8'))
    # Creating signature
    message = header_b64 + "." + payload_b64
    signature = hmac.new(_secret, message.encode('ascii'), digestmod='sha256').digest()
    signature_b64 = b64encode(signature)
    # Combining three parts to create the final JWT
    jwt = message + "." + signature_b64
    return jwt

def get_userJWT(userID):
    """
    Parameter:
    userID      The userID used to generate JWT
    JWT Payload form:
    userID:     id
    iat:        unix timestamp form time
    """
    # Set payload
    payload = {"userID":str(userID),"iat":str(time.time())}
    # Generate JWT
    userJWT = JWTgenerator(payload)
    return userJWT
