//TEST:SIMPLE(filecheck=UINT): -target metal -stage vertex -entry uintId
//TEST:SIMPLE(filecheck=INT): -target metal -stage vertex -entry intId
//TEST:SIMPLE(filecheck=USHORT): -target metal -stage vertex -entry ushortId
//TEST:SIMPLE(filecheck=SHORT): -target metal -stage vertex -entry shortId
//TEST:SIMPLE(filecheck=USHORT_AFTER): -target metal -stage vertex -entry ushortIdBaseAfter
//TEST:SIMPLE(filecheck=USHORT_BEFORE): -target metal -stage vertex -entry ushortIdBaseBefore
//TEST:SIMPLE(filecheck=SHORT_AFTER): -target metal -stage vertex -entry shortIdBaseAfter
//TEST:SIMPLE(filecheck=SHORT_BEFORE): -target metal -stage vertex -entry shortIdBaseBefore

// The native difference is converted to the declared ID type, not the other way around.
// UINT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// UINT-NOT: {{ - }}
// UINT: float([[V]] - [[B]])
// UINT-NOT: {{ - }}
[shader("vertex")]
float4 uintId(uint v : SV_VertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// INT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// INT-NOT: {{ - }}
// INT: float(int([[V]] - [[B]]))
// INT-NOT: {{ - }}
[shader("vertex")]
float4 intId(int v : SV_VertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// USHORT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// USHORT-NOT: {{ - }}
// USHORT: float(ushort([[V]] - [[B]]))
// USHORT-NOT: {{ - }}
[shader("vertex")]
float4 ushortId(uint16_t v : SV_VertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// SHORT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// SHORT-NOT: {{ - }}
// SHORT: float(short([[V]] - [[B]]))
// SHORT-NOT: {{ - }}
[shader("vertex")]
float4 shortId(int16_t v : SV_VertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// The shader's own base value still narrows, independently of the native-width correction.
// USHORT_AFTER: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// USHORT_AFTER-NOT: {{ - }}
// USHORT_AFTER: float(ushort([[V]] - [[B]])), float(ushort([[B]]))
// USHORT_AFTER-NOT: {{ - }}
[shader("vertex")]
float4 ushortIdBaseAfter(uint16_t v : SV_VertexID, uint16_t b : SV_StartVertexLocation)
    : SV_Position
{
    return float4(v, b, 0, 1);
}

// USHORT_BEFORE: (uint [[B:[^ ]+]] {{\[\[}}base_vertex]], uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// USHORT_BEFORE-NOT: {{ - }}
// USHORT_BEFORE: float(ushort([[V]] - [[B]])), float(ushort([[B]]))
// USHORT_BEFORE-NOT: {{ - }}
[shader("vertex")]
float4 ushortIdBaseBefore(uint16_t b : SV_StartVertexLocation, uint16_t v : SV_VertexID)
    : SV_Position
{
    return float4(v, b, 0, 1);
}

// SHORT_AFTER: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// SHORT_AFTER-NOT: {{ - }}
// SHORT_AFTER: float(short([[V]] - [[B]])), float(int([[B]]))
// SHORT_AFTER-NOT: {{ - }}
[shader("vertex")]
float4 shortIdBaseAfter(int16_t v : SV_VertexID, int b : SV_StartVertexLocation) : SV_Position
{
    return float4(v, b, 0, 1);
}

// SHORT_BEFORE: (uint [[B:[^ ]+]] {{\[\[}}base_vertex]], uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// SHORT_BEFORE-NOT: {{ - }}
// SHORT_BEFORE: float(short([[V]] - [[B]])), float(int([[B]]))
// SHORT_BEFORE-NOT: {{ - }}
[shader("vertex")]
float4 shortIdBaseBefore(int b : SV_StartVertexLocation, int16_t v : SV_VertexID) : SV_Position
{
    return float4(v, b, 0, 1);
}
