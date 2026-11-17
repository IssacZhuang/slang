//TEST:SIMPLE(filecheck=UINT): -target metal -stage vertex -entry vulkanUintId
//TEST:SIMPLE(filecheck=INT): -target metal -stage vertex -entry vulkanIntId
//TEST:SIMPLE(filecheck=USHORT): -target metal -stage vertex -entry vulkanUshortId
//TEST:SIMPLE(filecheck=SHORT): -target metal -stage vertex -entry vulkanShortId
//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry vulkanBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry vulkanBaseBefore

// SV_VulkanVertexID is already absolute: no synthesized base and no correction.
// UINT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// UINT-NOT: base_vertex
// UINT-NOT: {{ - }}
// UINT: float([[V]])
// UINT-NOT: {{ - }}
[shader("vertex")]
float4 vulkanUintId(uint v : SV_VulkanVertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// INT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// INT-NOT: base_vertex
// INT-NOT: {{ - }}
// INT: float(int([[V]]))
// INT-NOT: {{ - }}
[shader("vertex")]
float4 vulkanIntId(int v : SV_VulkanVertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// USHORT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// USHORT-NOT: base_vertex
// USHORT-NOT: {{ - }}
// USHORT: float(ushort([[V]]))
// USHORT-NOT: {{ - }}
[shader("vertex")]
float4 vulkanUshortId(uint16_t v : SV_VulkanVertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// SHORT: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// SHORT-NOT: base_vertex
// SHORT-NOT: {{ - }}
// SHORT: float(short([[V]]))
// SHORT-NOT: {{ - }}
[shader("vertex")]
float4 vulkanShortId(int16_t v : SV_VulkanVertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}

// Declaring and using a base must not make the absolute vertex ID base-relative.
// AFTER: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// AFTER-NOT: {{ - }}
// AFTER: float([[V]]), float(ushort([[B]]))
// AFTER-NOT: {{ - }}
[shader("vertex")]
float4 vulkanBaseAfter(uint v : SV_VulkanVertexID, uint16_t b : SV_StartVertexLocation)
    : SV_Position
{
    return float4(v, b, 0, 1);
}

// BEFORE: (uint [[B:[^ ]+]] {{\[\[}}base_vertex]], uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// BEFORE-NOT: {{ - }}
// BEFORE: float([[V]]), float(ushort([[B]]))
// BEFORE-NOT: {{ - }}
[shader("vertex")]
float4 vulkanBaseBefore(uint16_t b : SV_StartVertexLocation, uint v : SV_VulkanVertexID)
    : SV_Position
{
    return float4(v, b, 0, 1);
}
