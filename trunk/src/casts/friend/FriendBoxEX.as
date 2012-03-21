package casts.friend
{
   import _facebook.FBMgr;
   
   import _myui.form.FriendBox;
   
   import com.adobe.serialization.json.JSON;
   import com.greensock.TweenMax;
   import com.greensock.events.LoaderEvent;
   import com.greensock.loading.DataLoader;
   import com.greensock.loading.LoaderMax;
   
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class FriendBoxEX extends FriendBox
   {
      // fla
      public var tfName:TextField;
      public var mc1:MovieClip;
      
      public var nickname:String;
      public var uid:String;
      public var onClickEvt:Function;
      public var onOverEvt:Function;
      public var onOutEvt:Function;
      
      // lock
      private var lock:Boolean = false;
      
      // loader
      private var loaderPapa:LoaderMax = new LoaderMax();
      
      public function FriendBoxEX()
      {
         super(33, 33); // width, height
         
         photo.x = 0;
         photo.y = 0;
         mc1.addChild(photo);
      }
      
      // ________________________________________________
      //                                           bitmap

      public function loadPicture():LoaderMax
      {
         buttonMode = false;
         
         loaderPapa.dispose(true);
         loaderPapa = new LoaderMax({
            auditSize:false,
            onComplete:function(e:LoaderEvent)
            {
               buttonMode = true;
            }
         });
         
         var url:String = 'https://graph.facebook.com/' + uid + '?fields=picture&type=square&access_token=' + FBMgr.api.access_token;
         var infoLoader:DataLoader = new DataLoader(url, {onComplete:onGetFutherInfo});
         
         loaderPapa.append(infoLoader);
         return loaderPapa;
      }
      
      public function get bmpData():BitmapData
      {
         if (photo.photo && photo.photo.bitmapData)
         {
            return photo.photo.bitmapData;
         }
         else
         {
            return null;
         }
      }
      
      // ________________________________________________
      //                         highlight/enable/disable
      
      public function enableIt():void
      {
         buttonMode = true;
         alpha = 1;
      }
      
      public function disableIt():void
      {
         buttonMode = false;
         alpha = 0.5;
      }
      
      public function highlightIt():void
      {
         lock = true;
         
         TweenMax.to(tfName, 0.2, {colorTransform:{tint:0xFC660C, tintAmount:1.0}});
         TweenMax2.frameTo(this, 'totalFrames');
      }
      
      public function unHighlightIt():void
      {
         lock = false;
         
         TweenMax.to(tfName, 0.2, {colorTransform:{tint:0xFC660C, tintAmount:0.0}});
         TweenMax2.frameTo(this, 1);
      }
      
      // ################### protected ##################
      
      // ________________________________________________
      //                                    mouse handler
      
      override protected function onOver(e:MouseEvent):void
      {
         if (onOverEvt as Function)
         {
            onOverEvt(e);
         }
         
         if (!buttonMode || lock) return;
         TweenMax2.frameTo(this, 'totalFrames');
      }
      
      override protected function onOut(e:MouseEvent):void
      {
         if (onOutEvt as Function)
         {
            onOutEvt(e);
         }
         
         if (!buttonMode || lock) return;
         TweenMax2.frameTo(this, 1);
      }
      
      override protected function onClick(e:MouseEvent):void
      {
         if (!buttonMode) return;
         if (onClickEvt as Function)
         {
            onClickEvt(e);
         }
      }
      
      // ________________________________________________
      //                                         callback
      
      protected function onGetFutherInfo(e:LoaderEvent):void
      {
         var loader:DataLoader = DataLoader(e.target);
         var data:Object = JSON.decode(loader.content) as Object;
         
         if (data.hasOwnProperty('picture'))
         {
            loaderPapa.append(photo.getLoader(new String(data.picture)));
         }
      }
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}