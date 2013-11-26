package
{

    import flash.display.Sprite;
    import flash.text.TextField;

    public class Lib extends Sprite
    {
        public function Lib()
        {
            var textField:TextField = new TextField();
            textField.text = "Hello, World";
            addChild( textField );
        }
    }
}
