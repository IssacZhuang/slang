//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry instanceBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry instanceBaseBefore
//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry instanceUnusedBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry instanceUnusedBaseBefore
//TEST:SIMPLE(filecheck=USHORT): -target metal -stage vertex -entry instanceUshortId
//TEST:SIMPLE(filecheck=SHORT): -target metal -stage vertex -entry instanceShortId
//TEST:SIMPLE(filecheck=USHORT_AFTER): -target metal -stage vertex -entry instanceUshortBaseAfter
//TEST:SIMPLE(filecheck=USHORT_BEFORE): -target metal -stage vertex -entry instanceUshortBaseBefore

// SV_InstanceID uses the same native-width dependency/type ordering as SV_VertexID.
// AFTER: (uint [[I:[^ ]+]] {{\[\[}}instance_id]], uint [[B:[^ ]+]] {{\[\[}}base_instance]])
// AFTER-NOT: {{ - }}
// AFTER: float([[I]] - [[B]])
// AFTER-NOT: {{ - }}
// BEFORE: (uint [[B:[^ ]+]] {{\[\[}}base_instance]], uint [[I:[^ ]+]] {{\[\[}}instance_id]])
// BEFORE-NOT: {{ - }}
// BEFORE: float([[I]] - [[B]])
// BEFORE-NOT: {{ - }}

[shader("vertex")]
float4 instanceBaseAfter(uint i : SV_InstanceID, uint16_t b : SV_StartInstanceLocation)
    : SV_Position
{
    return float4(i, b, 0, 1);
}

[shader("vertex")]
float4 instanceBaseBefore(uint16_t b : SV_StartInstanceLocation, uint i : SV_InstanceID)
    : SV_Position
{
    return float4(i, b, 0, 1);
}

[shader("vertex")]
float4 instanceUnusedBaseAfter(uint i : SV_InstanceID, uint16_t b : SV_StartInstanceLocation)
    : SV_Position
{
    return float4(i, 0, 0, 1);
}

[shader("vertex")]
float4 instanceUnusedBaseBefore(uint16_t b : SV_StartInstanceLocation, uint i : SV_InstanceID)
    : SV_Position
{
    return float4(i, 0, 0, 1);
}

// USHORT: (uint [[I:[^ ]+]] {{\[\[}}instance_id]], uint [[B:[^ ]+]] {{\[\[}}base_instance]])
// USHORT-NOT: {{ - }}
// USHORT: float(ushort([[I]] - [[B]]))
// USHORT-NOT: {{ - }}
[shader("vertex")]
float4 instanceUshortId(uint16_t i : SV_InstanceID) : SV_Position
{
    return float4(i, 0, 0, 1);
}

// SHORT: (uint [[I:[^ ]+]] {{\[\[}}instance_id]], uint [[B:[^ ]+]] {{\[\[}}base_instance]])
// SHORT-NOT: {{ - }}
// SHORT: float(short([[I]] - [[B]]))
// SHORT-NOT: {{ - }}
[shader("vertex")]
float4 instanceShortId(int16_t i : SV_InstanceID) : SV_Position
{
    return float4(i, 0, 0, 1);
}

// USHORT_AFTER: (uint [[I:[^ ]+]] {{\[\[}}instance_id]], uint [[B:[^ ]+]] {{\[\[}}base_instance]])
// USHORT_AFTER-NOT: {{ - }}
// USHORT_AFTER: float(ushort([[I]] - [[B]])), float(ushort([[B]]))
// USHORT_AFTER-NOT: {{ - }}
[shader("vertex")]
float4 instanceUshortBaseAfter(uint16_t i : SV_InstanceID, uint16_t b : SV_StartInstanceLocation)
    : SV_Position
{
    return float4(i, b, 0, 1);
}

// USHORT_BEFORE: (uint [[B:[^ ]+]] {{\[\[}}base_instance]], uint [[I:[^ ]+]] {{\[\[}}instance_id]])
// USHORT_BEFORE-NOT: {{ - }}
// USHORT_BEFORE: float(ushort([[I]] - [[B]])), float(ushort([[B]]))
// USHORT_BEFORE-NOT: {{ - }}
[shader("vertex")]
float4 instanceUshortBaseBefore(uint16_t b : SV_StartInstanceLocation, uint16_t i : SV_InstanceID)
    : SV_Position
{
    return float4(i, b, 0, 1);
}
