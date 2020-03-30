package ceramic;

/** Draw shapes by triangulating vertices automatically, with optional holes in it. */
class Shape extends Mesh {

    /** A flat array of vertex coordinates to describe the shape.
        `points = ...` is identical to `vertices = ... ; contentDirty = true ;`
        Note: when editing array content without reassigning it,
        `contentDirty` must be set to `true` to let the shape being updated accordingly. */
    public var points(get, set):Array<Float>;
    inline function get_points():Array<Float> {
        return vertices;
    }
    inline function set_points(points:Array<Float>):Array<Float> {
        this.vertices = points;
        contentDirty = true;
        return points;
    }

    /** An array of hole indices, if any.
        (e.g. `[5, 8]` for a 12-vertex input would mean
        one hole with vertices 5–7 and another with 8–11).
        Note: when editing array content without reassigning it,
        `contentDirty` must be set to `true` to let the shape being updated accordingly. */
    public var holes:Array<Int> = null;
    inline function set_holes(holes:Array<Int>):Array<Int> {
        this.holes = holes;
        contentDirty = true;
        return holes;
    }

    /** If set to `true`, width and heigh will be computed from shape points. */
    public var autoComputeSize(default, set):Bool = true;
    inline function set_autoComputeSize(autoComputeSize:Bool):Bool {
        if (this.autoComputeSize == autoComputeSize) return autoComputeSize;
        this.autoComputeSize = autoComputeSize;
        if (autoComputeSize)
            computeSize();
        return autoComputeSize;
    }

    override function computeContent() {

        if (vertices != null && vertices.length >= 6) {

            if (indices == null)
                indices = [];

            if (holes != null && holes.length > 0) {
                Triangulate.triangulate(vertices, indices, holes);
            }
            else {
                Triangulate.triangulate(vertices, indices);
            }
        }

        if (autoComputeSize)
            computeSize();

        contentDirty = false;

    }

}