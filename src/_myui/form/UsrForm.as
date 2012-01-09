package _myui.form
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.text.TextField;
   
   public class UsrForm extends MovieClip
   {
      // fla
      public var tfName:TextField;
      public var tfEmail:TextField;
      public var tfTel:TextField;
      public var tfAddr:TextField;
      public var tfId:TextField;
      
      // helper
      private var submitHelper:SubmitHelper;
      private var tfHelper:TextfieldHelper;
      
      public function UsrForm()
      {
         // helper
         tfHelper = new TextfieldHelper();
         tfHelper.add([tfName, tfEmail, tfTel, tfAddr, tfId]);
         tfHelper.restrictEmail(tfEmail);
         tfHelper.restrictTel(tfId);
         tfHelper.restrictID(tfId);
         
         submitHelper = new SubmitHelper('http://123.com/submit.php', onSended, onIOErr);
      }
      
      // --------------------- LINE ---------------------
      
      public function check():Boolean
      {
         // trim space
         tfHelper.trimRight();
         
         var ret:Boolean = false;
         // check
         if (tfName.text.length == 0)
         {
            trace('請填寫您的大名哦！');
         }
         else if (tfTel.text.length == 0)
         {
            trace('請填寫您的聯絡電話哦！');
         }
         else if (tfAddr.text.length == 0)
         {
            trace('請填寫您的聯絡地址！');
         }
         else if (tfId.text.length == 0 || tfId.text.search(/^[A-Za-z]{1}[0-9]{9}$/) == -1)
         {
            trace('請填有效身份證字號！');
         }
         else if (tfEmail.text.length == 0 || tfEmail.text.search(/@/) == -1)
         {
            trace('請填寫您的有效Email！');
         }
         else
         {
            ret = true;
         }
         
         return ret;
      }
      
      public function submit():void
      {
         if (check())
         {
            submitHelper.addGETVars('usr_name', tfName.text);
            submitHelper.addGETVars('usr_email', tfEmail.text);
            submitHelper.addGETVars('usr_tel', tfTel.text);
            submitHelper.addGETVars('usr_addr', tfAddr.text);
            submitHelper.addGETVars('usr_id', tfId.text);
            
            submitHelper.send();
         }
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onIOErr(e:IOErrorEvent):void
      {
      }
      
      private function onSended(e:Event):void
      {
         trace(submitHelper.data);
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}