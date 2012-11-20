package dof.body.api
{
	public interface IFace
	{
		function get v1():IVertex;
		function get v2():IVertex;
		function get v3():IVertex;
		
		function get vertices():Vector.<IVertex>;
	}
}