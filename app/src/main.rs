use axum::{
    http::{header, StatusCode},
    response::{IntoResponse, Json},
    routing::get,
    Router,
};
use serde::{Deserialize, Serialize};
use std::env;
use tokio::net::TcpListener;

#[tokio::main]
async fn main() {
    let app = Router::new().route("/info", get(info));

    let listener = TcpListener::bind("0.0.0.0:8080").await.unwrap();
    println!("listening on {}", listener.local_addr().unwrap());
    axum::serve(listener, app).await.unwrap();
}

#[derive(Serialize, Deserialize)]
struct PodInfo {
    pod_ip: String,
}

async fn info() -> impl IntoResponse {
    let pod_ip = env::var("POD_IP").unwrap_or_else(|_| "unknown".to_string());

    let pod_info = PodInfo {
        pod_ip: pod_ip.clone(),
    };

    let mut headers = header::HeaderMap::new();
    headers.insert("x-pod-ip", pod_ip.parse().unwrap());

    (StatusCode::OK, headers, Json(pod_info))
}
