// [[instance_id]] counts from the base instance, SV_InstanceID counts from zero, and
// SV_VulkanInstanceID has gl_InstanceIndex semantics, so only SV_InstanceID subtracts.

//TEST:SIMPLE(filecheck=UINT): -target metal -stage vertex -entry vertUint
//TEST:SIMPLE(filecheck=HLSL): -target metal -stage vertex -entry vertMain
//TEST:SIMPLE(filecheck=VULKAN): -target metal -stage vertex -entry vertVulkan
//TEST:SIMPLE(filecheck=BOTH): -target metal -stage vertex -entry vertBoth
//TEST:SIMPLE(filecheck=MIXED): -target metal -stage vertex -entry vertMixed
//TEST:SIMPLE(filecheck=BOTHINT): -target metal -stage vertex -entry vertBothInt
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertUint
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertMain
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertVulkan
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertBoth
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertMixed
//TEST:SIMPLE(filecheck=METALLIB): -target metallib -stage vertex -entry vertBothInt

// METALLIB: result code = 0

// UINT: vertUint(uint {{[^,]*}}instance_id]], uint {{[^,]*}}base_instance]])
// UINT: i{{[0-9_]*}} - base_instance{{[0-9_]*}}
[shader("vertex")]
float4 vertUint(uint i : SV_InstanceID) : SV_Position
{
    return i;
}

// HLSL-DAG: instance_id]]
// HLSL-DAG: base_instance]]
// HLSL: int(i{{[0-9_]*}} - base_instance{{[0-9_]*}})
[shader("vertex")]
float4 vertMain(int i : SV_InstanceID) : SV_Position
{
    return i;
}

// VULKAN: instance_id]])
// VULKAN-NOT: base_instance
[shader("vertex")]
float4 vertVulkan(uint i : SV_VulkanInstanceID) : SV_Position
{
    return i;
}

// An explicit SV_StartInstanceLocation is reused rather than declared a second time.
// BOTH: vertBoth(uint {{[^,]*}}instance_id]], uint {{[^,]*}}base_instance]])
// BOTH: i{{[0-9_]*}} - base{{[0-9_]*}} + base{{[0-9_]*}}
[shader("vertex")]
float4 vertBoth(uint i : SV_InstanceID, uint base : SV_StartInstanceLocation) : SV_Position
{
    return i + base;
}

// The native difference is converted to the declared type of SV_InstanceID.
// MIXED: vertMixed(uint {{[^,]*}}instance_id]], uint {{[^,]*}}base_instance]])
// MIXED: int(i{{[0-9_]*}} - base{{[0-9_]*}}) + int(base{{[0-9_]*}})
[shader("vertex")]
float4 vertMixed(int i : SV_InstanceID, uint base : SV_StartInstanceLocation) : SV_Position
{
    return i + int(base);
}

// A reused base declared after SV_InstanceID keeps its independent signed conversion.
// BOTHINT: vertBothInt(uint {{[^,]*}}instance_id]], uint {{[^,]*}}base_instance]])
// BOTHINT: int(i{{[0-9_]*}} - base{{[0-9_]*}}) + int(base{{[0-9_]*}})
[shader("vertex")]
float4 vertBothInt(int i : SV_InstanceID, int base : SV_StartInstanceLocation) : SV_Position
{
    return i + base;
}
