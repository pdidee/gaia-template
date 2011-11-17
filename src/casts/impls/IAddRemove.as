package casts.impls
{
   import flash.events.Event;

   public interface IAddRemove
   {
      // Event.ADDED_TO_STAGE
      function onAdd(e:Event):void;
      // Event.REMOVED_FROM_STAGE
      function onRemove(e:Event):void;
   }
}