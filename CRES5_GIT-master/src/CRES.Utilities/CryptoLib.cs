using System;
using System.Security.Cryptography;
using System.Text;

namespace CRES.Utilities
{
    public static class Encryptor
    {
        public static string MD5Hash(string text)
        {
            MD5 md5 = new MD5CryptoServiceProvider();

            //compute hash from the bytes of text
            md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(text));

            //get hash result after compute it
            byte[] result = md5.Hash;

            StringBuilder strBuilder = new StringBuilder();
            for (int i = 0; i < result.Length; i++)
            {
                //change it into 2 hexadecimal digits
                //for each byte
                strBuilder.Append(result[i].ToString("x2"));
            }

            return strBuilder.ToString();
        }

        public static string GenerateStrongPassword()
        {
            Random rnd = new Random();
            // Combination of password is CAP + low + low + low + low + low + Num + SpecialCharacter(!"#$%&)
            string newPassword =
                Char.ConvertFromUtf32(rnd.Next(65, 91)) +   //CAP
                Char.ConvertFromUtf32(rnd.Next(97, 123)) +  //low
                Char.ConvertFromUtf32(rnd.Next(97, 123)) +  //low
                Char.ConvertFromUtf32(rnd.Next(97, 123)) +  //low
                Char.ConvertFromUtf32(rnd.Next(97, 123)) +  //low
                Char.ConvertFromUtf32(rnd.Next(97, 123)) +  //low
                Char.ConvertFromUtf32(rnd.Next(48, 58)) +   //Num
                Char.ConvertFromUtf32(rnd.Next(33, 39));    //Special ! " # $ % &
            return newPassword;
        }
    }
}