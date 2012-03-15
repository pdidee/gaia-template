package
{
   import _facebook.FBMgr;
   
   import _myui.form.SubmitHelper;
   
   import com.adobe.images.JPGEncoder;
   import com.gaiaframework.templates.AbstractPage;
   
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   
   public class Test extends AbstractPage
   {
      // fla
      public var btn1:MyButton;
      public var btn2:MyButton;
      public var btn3:MyButton;
      public var btn4:MyButton;
      public var btn5:MyButton;
      public var btn6:MyButton;
      public var btn7:MyButton;
      public var btn8:MyButton;
      public var btn9:MyButton;
      public var btn10:MyButton;
      
      // picture
      public var pic:BitmapData;
      
      // loader
      private var bmode:uint = 1;
      private var dataLoader:SubmitHelper = new SubmitHelper();
      
      public function Test()
      {
         super();
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // --------------------- LINE ---------------------
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         transitionOutComplete();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      private function onAdd(e:Event):void
      {
         // basic
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         
         // js callback
         if (ExternalInterface.available)
         {
            ExternalInterface.call('initSWF');
         }
         
         gotoAndStop(1);
         
         // fb
         var paramObj:Object = stage.loaderInfo.parameters;
         FBMgr.api.init(paramObj, gotoStep1);
         
         // pic
         var picCls:Class = getDefinitionByName('GGGGG') as Class;
         pic = new picCls();
      }
      
      private function onRemove(e:Event):void
      {
      }
      
      // --------------------- LINE ---------------------
      
      private function gotoStep1():void
      {
         gotoAndStop(2);
         // login
         btn1.buttonMode = true;
         btn1.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            this.alpha = 0.5;
            
            // login >> get albums >> create album
            FBMgr.api.login(getAlbums);
         };
      }
      
      private function getAlbums():void
      {
         if (FBMgr.api.isLogin)
         {
            FBMgr.api.getAlbums(createAlbum);
         }
         else
         {
            btn1.buttonMode = true;
            btn1.alpha = 1;
         }
      }
      
      private function createAlbum():void
      {
         FBMgr.api.createAlbum('test xxx', 'test message', gotoStep2);
      }
      
      private function gotoStep2():void
      {
         gotoAndStop(3);
         // friend
         btn2.gotoAndStop(1);
         btn2.buttonMode = true;
         btn2.onClick = function()
         {
            FBMgr.api.getFriends();
         };
         // 站內分享
         btn3.gotoAndStop(1);
         btn3.buttonMode = true;
         btn3.onClick = function()
         {
            FBMgr.api.postAppreq_UI('快來和我一起測試app吧！', ['1652211998','1707871391','1533156624']);
         };
         // 跳窗分享
         btn4.gotoAndStop(1);
         btn4.buttonMode = true;
         btn4.onClick = function()
         {
            //            FBMgr.api.publishFeed_Sharer();
         };
         // 創相簿
         btn5.gotoAndStop(1);
         btn5.buttonMode = true;
         btn5.onClick = function()
         {
            createAlbum();
         };
         // 上傳相片
         btn6.gotoAndStop(1);
         btn6.buttonMode = true;
         btn6.onClick = function()
         {
            var bmp:Bitmap = new Bitmap(pic);
            var ba:ByteArray = new JPGEncoder(80).encode(pic);
            FBMgr.api.postPhoto(FBMgr.api.latest_aid, 'test photo message 1', pic, photoComplete);
            FBMgr.api.postPhoto(FBMgr.api.latest_aid, 'test photo message 2', pic, photoComplete);
            FBMgr.api.postPhoto(FBMgr.api.latest_aid, 'test photo message 3', pic, photoComplete);
         };
         // 測試用
         btn7.gotoAndStop(1);
         btn7.buttonMode = true;
         btn7.onClick = function()
         {
            doitByBMode();
         };
         btn8.gotoAndStop(1);
         btn8.buttonMode = true;
         btn8.onClick = function()
         {
            Trace2('{as} Verify...');
            dataLoader.stop();
            dataLoader.removeVars();
            dataLoader.addGETVars('fb_id', FBMgr.api.uid);
            dataLoader.addGETVars('photo_no', 0);
            dataLoader.send('http://fb.mo2.com.tw/Moulin/jlin12/func/Verify.php', 
               function(e:Event)
               {
                  Trace2(e.target.data);
               },
               function(e:IOErrorEvent)
               {
               }
            );
         };
         btn9.gotoAndStop(1);
         btn9.buttonMode = true;
         btn9.onClick = function()
         {
            Trace2('{as} NotifyAll...');
            dataLoader.stop();
            dataLoader.removeVars();
            dataLoader.addGETVars('photo_no', 0);
            dataLoader.send('http://fb.mo2.com.tw/Moulin/jlin12/func/NotifyAll.php', 
               function(e:Event)
               {
                  Trace2(e.target.data);
               },
               function(e:IOErrorEvent)
               {
               }
            );
         };
         btn10.gotoAndStop(1);
         btn10.buttonMode = true;
         btn10.onClick = function()
         {
            Trace2('{as} GetLatestPhotoNo...');
            dataLoader.stop();
            dataLoader.removeVars();
            dataLoader.send('http://fb.mo2.com.tw/Moulin/jlin12/func/GetLatestPhotoNo.php', 
               function(e:Event)
               {
                  Trace2(e.target.data);
               },
               function(e:IOErrorEvent)
               {
               }
            );
         };
      }
      
      // --------------------- LINE ---------------------
      
      private function photoComplete():void
      {
      }
      
      private function doitByBMode():void
      {
         if (!btn7.buttonMode) return;
         btn7.buttonMode = false;
         btn7.alpha = 0.5;
         
         switch(bmode)
         {
            case 1:
               dataLoader.stop();
               dataLoader.removeVars();
               dataLoader.addGETVars('nickname', FBMgr.api.name);
               dataLoader.addGETVars('fb_token', FBMgr.api.access_token);
               dataLoader.addGETVars('email', FBMgr.api.email);
               dataLoader.addGETVars('comment', "It's a test comment\nGood luck!!!");
               dataLoader.addGETVars('photo_no', 0);
               dataLoader.addGETVars('xx', 2);
               dataLoader.addGETVars('yy', 2);
               dataLoader.addGETVars('profile_img', FBMgr.api.pic_url_square);
               dataLoader.send('http://fb.mo2.com.tw/Moulin/jlin12/func/Submit.php', sendSuccess, sendFail);
               break;
            case 2:
               dataLoader.stop();
               dataLoader.removeVars();
               dataLoader.addGETVars('photo_no', 0);
               dataLoader.send('http://fb.mo2.com.tw/Moulin/jlin12/func/GetPhotoInfo.php', sendSuccess, sendFail);
               break;
         }
      }
      
      private function changeMode():void
      {
         switch(bmode)
         {
            case 1:
               bmode = 2;
               break;
            case 2:
               bmode = 1;
               break;
         }
         Trace2('{as} changeMode | mode = ' + bmode);
      }
      
      private function sendSuccess(e:Event):void
      {
         btn7.buttonMode = true;
         btn7.alpha = 1;
         
         changeMode();
         Trace2('{as} sendSuccess | data = ', e.target.data);
      }
      
      private function sendFail(e:IOErrorEvent):void
      {
         btn7.buttonMode = true;
         btn7.alpha = 1;
         
         changeMode();
         Trace2('fail');
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}
