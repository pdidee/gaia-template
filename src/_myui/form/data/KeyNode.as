package _myui.form.data
{
   
   public class KeyNode
   {
      private var _datas:Vector.<Object>;
      private var _key:String;
      
      public function KeyNode(group:String)
      {
         _key = group;
         _datas = new Vector.<Object>();
      }
      
      // ________________________________________________
      //                                             data
      
      public function get key():String { return _key; }
      public function get datas():Vector.<Object> { return _datas; }
      
      // --------------------- LINE ---------------------
      
      public function push(obj:Object):void
      {
         _datas.push(obj);
      }
      
      public function pop():Object
      {
         return _datas.pop();
      }
      
      public function get(index:int):Object
      {
         return _datas[index];
      }
      
      public function remove(obj:Object):void
      {
         var no:int = _datas.indexOf(obj);
         if (no >= 0)
         {
            _datas.splice(no, 1);
         }
      }
      
      public function indexOf(obj:Object, fromIndex:int = 0):int
      {
         return _datas.indexOf(obj, fromIndex);
      }
      
      public function get length():uint { return _datas.length; }
      
      // ________________________________________________
      //                                            trace
      
      public function toString():String
      {
         return '"' + key + '" : ' + _datas;
      }
      
      // ################### protected ##################
      
      // #################### private ###################
      
      // --------------------- LINE ---------------------
      
   }
   
}