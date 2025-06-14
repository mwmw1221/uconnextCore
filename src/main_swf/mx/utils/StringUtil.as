package mx.utils
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class StringUtil
   {
      mx_internal static const VERSION:String = "4.1.0.16076";
      
      public function StringUtil()
      {
         super();
      }
      
      public static function trim(str:String) : String
      {
         if(str == null)
         {
            return "";
         }
         var startIndex:int = 0;
         while(isWhitespace(str.charAt(startIndex)))
         {
            startIndex++;
         }
         var endIndex:int = str.length - 1;
         while(isWhitespace(str.charAt(endIndex)))
         {
            endIndex--;
         }
         if(endIndex >= startIndex)
         {
            return str.slice(startIndex,endIndex + 1);
         }
         return "";
      }
      
      public static function trimArrayElements(value:String, delimiter:String) : String
      {
         var items:Array = null;
         var len:int = 0;
         var i:int = 0;
         if(value != "" && value != null)
         {
            items = value.split(delimiter);
            len = int(items.length);
            for(i = 0; i < len; i++)
            {
               items[i] = StringUtil.trim(items[i]);
            }
            if(len > 0)
            {
               value = items.join(delimiter);
            }
         }
         return value;
      }
      
      public static function isWhitespace(character:String) : Boolean
      {
         switch(character)
         {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
               return true;
            default:
               return false;
         }
      }
      
      public static function substitute(str:String, ... rest) : String
      {
         var args:Array = null;
         if(str == null)
         {
            return "";
         }
         var len:uint = uint(rest.length);
         if(len == 1 && rest[0] is Array)
         {
            args = rest[0] as Array;
            len = args.length;
         }
         else
         {
            args = rest;
         }
         for(var i:int = 0; i < len; i++)
         {
            str = str.replace(new RegExp("\\{" + i + "\\}","g"),args[i]);
         }
         return str;
      }
      
      public static function repeat(str:String, n:int) : String
      {
         if(n == 0)
         {
            return "";
         }
         var s:String = str;
         for(var i:int = 1; i < n; i++)
         {
            s += str;
         }
         return s;
      }
      
      public static function restrict(str:String, restrict:String) : String
      {
         var charCode:uint = 0;
         if(restrict == null)
         {
            return str;
         }
         if(restrict == "")
         {
            return "";
         }
         var charCodes:Array = [];
         var n:int = str.length;
         for(var i:int = 0; i < n; i++)
         {
            charCode = uint(str.charCodeAt(i));
            if(testCharacter(charCode,restrict))
            {
               charCodes.push(charCode);
            }
         }
         return String.fromCharCode.apply(null,charCodes);
      }
      
      private static function testCharacter(charCode:uint, restrict:String) : Boolean
      {
         var code:uint = 0;
         var acceptCode:Boolean = false;
         var allowIt:Boolean = false;
         var inBackSlash:Boolean = false;
         var inRange:Boolean = false;
         var setFlag:* = true;
         var lastCode:uint = 0;
         var n:int = restrict.length;
         if(n > 0)
         {
            code = uint(restrict.charCodeAt(0));
            if(code == 94)
            {
               allowIt = true;
            }
         }
         for(var i:int = 0; i < n; i++)
         {
            code = uint(restrict.charCodeAt(i));
            acceptCode = false;
            if(!inBackSlash)
            {
               if(code == 45)
               {
                  inRange = true;
               }
               else if(code == 94)
               {
                  setFlag = !setFlag;
               }
               else if(code == 92)
               {
                  inBackSlash = true;
               }
               else
               {
                  acceptCode = true;
               }
            }
            else
            {
               acceptCode = true;
               inBackSlash = false;
            }
            if(acceptCode)
            {
               if(inRange)
               {
                  if(lastCode <= charCode && charCode <= code)
                  {
                     allowIt = setFlag;
                  }
                  inRange = false;
                  lastCode = 0;
               }
               else
               {
                  if(charCode == code)
                  {
                     allowIt = setFlag;
                  }
                  lastCode = code;
               }
            }
         }
         return allowIt;
      }
   }
}

