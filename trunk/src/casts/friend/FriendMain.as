package casts.friend
{
   import _facebook.FBMgr;
   
   import _myui.scrollbar.VScrollBar1;
   
   import casts._lightbox.BaseLightbox;
   
   import com.greensock.TimelineMax;
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.greensock.loading.LoaderMax;
   import com.greensock.plugins.BlurFilterPlugin;
   import com.greensock.plugins.ColorTransformPlugin;
   import com.greensock.plugins.TweenPlugin;
   
   import flash.display.Bitmap;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class FriendMain extends BaseLightbox
   {
      // fla
      public var mcBody:MovieClip;
      public var mcLoading:MovieClip;
      // step
      public function get mcStep():MovieClip { return MovieClip(mcBody.mcStep); }
      // other
      public function get tfNo():TextField { return TextField(mcBody.tfNo); }
      public function get mcNo():MovieClip { return MovieClip(mcBody.mcNo); }
      public function get btnClose():MyButton { return MyButton(mcBody.btnClose); }
      public function get btnNext():MyButton { return MyButton(mcBody.btnNext); }
      public function get btnPrev():MyButton { return MyButton(mcBody.btnPrev); }
      public function get btnSubmit():MyButton { return MyButton(mcBody.btnSubmit); }
      public function get mcBox():MovieClip { return MovieClip(mcBody.mcStep.mcBox); }
      public function get btnVBar():VScrollBar1 { return VScrollBar1(mcBody.mcStep.btnVBar); }
      
      // box pool
      private var loaderPapa:LoaderMax;
      private var boxPool:Vector.<FriendBoxEX>;
      
      // select pool
      private const SELECT_MAX:int = 4; // selection limits.
      private var selectPool:Vector.<FriendBoxEX>;
      
      private const posX:Array = [-250, -812];
      
      public function FriendMain()
      {
         super();
         
         blendMode = BlendMode.LAYER;
         
         // gs
         TweenPlugin.activate([BlurFilterPlugin, ColorTransformPlugin]);
         
         addEventListener(Event.ADDED_TO_STAGE, onAdd);
         addEventListener(Event.REMOVED_FROM_STAGE, onRemove);
      }
      
      // ________________________________________________
      //                                       transition
      
      override public function transitionIn():void
      {
         super.transitionIn();
         transitionInComplete();
         
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
                  tryGetFriend();
               }
            }
         );
         
         // [init]
         TweenMax.to(this, 0, {autoAlpha:1});
         TweenMax.to(mcBody, 0, {frame:1, x:375, y:410, autoAlpha:0, scaleX:0.8, scaleY:0.8, blurFilter:{blurY:20}});
         // step
         TweenMax.to(mcStep, 0, {x:-250});
         // button
         initButton1();
         btnNext.buttonMode = false;
         TweenMax.to(btnNext, 0, {alpha:0.5});
         
         // [actions]
         cmd.insert(TweenMax.to(mcLoading, 0.3, {autoAlpha:1}));
         
         cmd.play();
      }
      
      override public function transitionInComplete():void
      {
         super.transitionInComplete();
         returnToParent();
      }
      
      override public function transitionOut():void
      {
         super.transitionOut();
         
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax(
            {
               onStart:function()
               {
               },
               onUpdate:function()
               {
               },
               onComplete:function()
               {
                  destroyScroll();
                  destroyNoView();
                  
                  transitionOutComplete();
               }
            }
         );
         
         // [init]
         // [actions]
         cmd.insert(TweenMax.to(mcBody, 0.2, {x:375, y:410, scaleX:0.8, scaleY:0.8, blurFilter:{blurY:20}}));
         cmd.insert(TweenMax.to(this, 0.2, {autoAlpha:0}));
         
         cmd.play();
      }
      
      override public function transitionOutComplete():void
      {
         super.transitionOutComplete();
         returnToParent();
      }
      
      // ################### protected ##################
      
      override protected function onStageResize(e:Event=null):void
      {
         x = (sw>>1) - (GB.DOC_WIDTH>>1);
         y = (sh>>1) - (GB.DOC_HEIGHT>>1);
      }
      
      // ________________________________________________
      //                                           slider
      
      protected function initScroll():void
      {
         if (!FBMgr.api.friends) return;
         
         var offx:Number = 170;
         var offy:Number = 49;
         
         // friend
         var boxHeight:Number = Math.floor(FBMgr.api.friends.length / 3) + 1;
         loaderPapa = new LoaderMax({auditSize:false});
         boxPool = new Vector.<FriendBoxEX>();
         for (var i:int = 0; i < FBMgr.api.friends.length; ++i) 
         {
            var box:FriendBoxEX = new FriendBoxEX();
            box.x = 0 + Math.floor(i%3) * offx;
            box.y = 0 + Math.floor(i/3) * offy;
            box.uid = FBMgr.api.friends[i].uid || '';
            box.tfName.text = box.nickname = FBMgr.api.friends[i].name || '';
            box.onOverEvt = onFBoxOver;
            box.onOutEvt = onFBoxOut;
            box.onClickEvt = onFBoxClick;
            mcBox.addChild(box);
            
            boxPool.push(box);
            
            loaderPapa.append(box.loadPicture());
         }
         loaderPapa.maxConnections = 20;
         loaderPapa.load();
         
         // box bg
         mcBox.graphics.clear();
         mcBox.graphics.beginFill(0x0000ff, 0);
         mcBox.graphics.drawRect(0, 0, 510, boxHeight * offy);
         mcBox.graphics.endFill();
         
         btnVBar.ta = mcBox;
         btnVBar.barRef = 235;
         btnVBar.mskRef = 280;
         btnVBar.taInitPos = new Point(5, 5);
         
         TweenMax.to(mcBox, 0, {x:btnVBar.taInitPos.x, y:btnVBar.taInitPos.y});
         
         // select
         selectPool = new Vector.<FriendBoxEX>();
      }
      
      protected function destroyScroll():void
      {
         while (mcBox.numChildren) mcBox.removeChildAt(0);
         if (loaderPapa) loaderPapa.dispose(true);
      }
      
      // ________________________________________________
      //                                           button
      
      protected function initButton1():void
      {
         btnClose.gotoAndStop(1);
         btnClose.buttonMode = true;
         btnClose.onClick = function()
         {
            if (!this.buttonMode) return;
            this.buttonMode = false;
            
            transitionOut();
         };
         
         btnNext.gotoAndStop(1);
         btnNext.buttonMode = true;
         btnNext.onClick = function()
         {
            if (!this.buttonMode) return;
            gotoStep2();
         };
      }
      
      protected function initButton2():void
      {
         btnPrev.gotoAndStop(1);
         btnPrev.buttonMode = true;
         btnPrev.onClick = function()
         {
            if (!this.buttonMode) return;
            gotoStep1();
         };
      }
      
      private function gotoStep1():void
      {
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax({
            onStart:function()
            {
            },
            onUpdate:function()
            {
            },
            onComplete:function()
            {
               mouseChildren = true;
            }
         });
         
         // [init]
         btnVBar.mgr.value = 0;
         mouseChildren = false;
         mcBody.gotoAndStop(1);
         initButton1();
         
         // [actions]
         cmd.insert(TweenMax.to(mcStep, 0.7, {x:posX[0], ease:Quint.easeInOut}));
         
         cmd.play();
      }
      
      private function gotoStep2():void
      {
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax({
            onStart:function()
            {
            },
            onUpdate:function()
            {
            },
            onComplete:function()
            {
               mouseChildren = true;
            }
         });
         
         // [init]
         mouseChildren = false;
         mcBody.gotoAndStop(2);
         initButton2();
         
         // [actions]
         cmd.insert(TweenMax.to(mcStep, 0.7, {x:posX[1], ease:Quint.easeInOut}));
         
         cmd.play();
      }
      
      // #################### private ###################
      
      private function onFBoxOver(e:MouseEvent):void
      {
      }
      
      private function onFBoxOut(e:MouseEvent):void
      {
      }

      private function onFBoxClick(e:MouseEvent):void
      {
         var btn:FriendBoxEX = FriendBoxEX(e.currentTarget);
         var no:int = selectPool.indexOf(btn);
         
         if (no == -1 && selectPool.length < SELECT_MAX)
         {
            selectPool.push(btn);
            btn.highlightIt();
         }
         else
         {
            selectPool.splice(no, 1);
            btn.unHighlightIt();
         }
         
         if (selectPool.length == SELECT_MAX)
         {
            for each (var i:FriendBoxEX in boxPool) 
            {
               if (-1 == selectPool.indexOf(i))
               {
                  i.disableIt();
               }
               else
               {
                  i.enableIt();
               }
            }
         }
         else
         {
            for each (i in boxPool) 
            {
               i.enableIt();
            }
         }
         
         updateNoView();
         updateButtonView();
      }
      
      private function updateNoView():void
      {
         destroyNoView();
         
         for (var i:int = 0; i < selectPool.length; ++i) 
         {
            if (selectPool[i].bmpData)
            {
               var bmp:Bitmap = new Bitmap(selectPool[i].bmpData.clone(), 'auto', true);
               bmp.width = 20;
               bmp.height = 20;
               bmp.x = i * 26;
               mcNo.addChild(bmp);
            }
         }
         
         // txt
         tfNo.text = '已選' + String(selectPool.length) + '位，最多' + SELECT_MAX + '位';
      }
      
      private function destroyNoView():void
      {
         while (mcNo.numChildren)
         {
            mcNo.removeChildAt(0);
         }
      }
      
      private function updateButtonView():void
      {
         if (currentFrame == 1)
         {
            if (selectPool.length == 0)
            {
               btnNext.buttonMode = false;
               btnNext.alpha = 0.5;
            }
            else
            {
               btnNext.buttonMode = true;
               btnNext.alpha = 1.0
            }
         }
         else if (currentFrame == 2)
         {
         }
      }
      
      // ________________________________________________
      //                                               fb
      
      private function tryGetFriend():void
      {
         if (!FBMgr.api.friends && GB.release)
         {
            FBMgr.api.getFriends(allDone);
         }
         else
         {
            allDone();
         }
      }
      
      private function allDone():void
      {
         // stop cmd(TimelineMax)
         cmd.stop();
         cmd.kill();
         cmd = new TimelineMax({
            onStart:function()
            {
            },
            onUpdate:function()
            {
            },
            onComplete:function()
            {
               destroyScroll();
               initScroll();
            }
         });
         
         // [init]
         
         // [actions]
         cmd.insert(TweenMax.to(mcLoading, 0.3, {autoAlpha:0}));
         cmd.insert(TweenMax.to(mcBody, 0.7, {x:375, y:410, autoAlpha:1, scaleX:1, scaleY:1, blurFilter:{blurY:0}, ease:Quint.easeOut}), 0.3);
         
         cmd.play();
      }
      
      // --------------------- LINE ---------------------
      
   }
   
}