[[block]]
struct Data {
    world: mat4x4<f32>;
    view: mat4x4<f32>;
    proj: mat4x4<f32>;
    time: f32;
};

struct VertexOutput {
    [[location(0)]] out_normal: vec3<f32>;
    [[location(1)]] out_color: vec3<f32>;
    [[builtin(position)]] out_pos: vec4<f32>;
};

[[group(0), binding(0)]]
var<uniform> uniforms: Data;

fn custom_inverse(m: mat3x3<f32>) -> mat3x3<f32> {
    let determinant: f32 = determinant(m);
    let invdet: f32 = 1.0 / determinant;
    var minv: mat3x3<f32>;
    minv[0][0] = (m[1][1] * m[2][2] - m[2][1] * m[1][2]) * invdet;
    minv[0][1] = (m[0][2] * m[2][1] - m[0][1] * m[2][2]) * invdet;
    minv[0][2] = (m[0][1] * m[1][2] - m[0][2] * m[1][1]) * invdet;
    minv[1][0] = (m[1][2] * m[2][0] - m[1][0] * m[2][2]) * invdet;
    minv[1][1] = (m[0][0] * m[2][2] - m[0][2] * m[2][0]) * invdet;
    minv[1][2] = (m[1][0] * m[0][2] - m[0][0] * m[1][2]) * invdet;
    minv[2][0] = (m[1][0] * m[2][1] - m[2][0] * m[1][1]) * invdet;
    minv[2][1] = (m[2][0] * m[0][1] - m[0][0] * m[2][1]) * invdet;
    minv[2][2] = (m[0][0] * m[1][1] - m[1][0] * m[0][1]) * invdet;
    return minv;
}

[[stage(vertex)]]
fn main(
    [[location(0)]] pos: vec3<f32>,
    [[location(1)]] normal: vec3<f32>,
    [[location(2)]] mat0: vec4<f32>,
    [[location(3)]] mat1: vec4<f32>,
    [[location(4)]] mat2: vec4<f32>,
    [[location(5)]] mat3: vec4<f32>,
    [[location(6)]] color: vec3<f32>,
) -> VertexOutput {
    let instance_transform: mat4x4<f32> = mat4x4<f32>(mat0, mat1, mat2, mat3);
    let worldview: mat4x4<f32> = uniforms.view * uniforms.world * instance_transform;
    let wv3: mat3x3<f32> = mat3x3<f32>(worldview[0].xyz, worldview[1].xyz, worldview[2].xyz);
    let out_normal: vec3<f32> = transpose(custom_inverse(wv3)) * normal;
    let out_pos: vec4<f32> = uniforms.proj * worldview * vec4<f32>(pos, 1.0);
    return VertexOutput(out_normal, color, out_pos);
}
