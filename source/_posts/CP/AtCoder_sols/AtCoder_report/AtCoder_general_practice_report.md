---
title: AtCoder 泛刷记录
date: 2025-08-25 21:00:00
categories:
  - CP
  - AtCoder 题解
# tags:
#   - DP
#   - 计算几何
mathjax: true
---

<!-- # AtCoder 泛刷记录 -->

## 简介

此文为本人泛刷 AtCoder 过程中遇到题目的简要题解，目的包括但不限于总结题目的思维链。

> 折叠的代码中有原题链接方便跳转。

## 正文

### ARC058B

- 整个图明显可以划分为两个子问题（合法区域分割为上下两个矩形）
- 分割线作为边界，枚举点进入分割线的入口进行统计即可。

> 扩展：如果题目改为 禁入矩形区域 在中间（而不是固定在左下角），那就考虑反面，枚举第一次进入禁入区域的点进行统计。

<details>

<summary>展开</summary>

```cpp
// Problem: D - Iroha and a Grid
// Contest: AtCoder - AtCoder Regular Contest 058
// URL: https://atcoder.jp/contests/arc058/tasks/arc058_b
// Memory Limit: 256 MB
// Time Limit: 2000 ms
// 
// Powered by CP Editor (https://cpeditor.org)

#include<bits/stdc++.h>
using namespace std;
 
#define debug(x) cerr << #x << ": " << (x) << endl
#define rep(i,a,b) for(int i=(a);i<=(b);i++)
#define dwn(i,a,b) for(int i=(a);i>=(b);i--)
#define SZ(a) ((int) (a).size())
#define pb push_back
#define all(x) (x).begin(), (x).end()
 
#define x first
#define y second
#define int long long
using pii = pair<int, int>;
using ll = long long;
 
inline void read(int &x){
    int s=0; x=1;
    char ch=getchar();
    while(ch<'0' || ch>'9') {if(ch=='-')x=-1;ch=getchar();}
    while(ch>='0' && ch<='9') s=(s<<3)+(s<<1)+ch-'0',ch=getchar();
    x*=s;
}

const int N=2e5+5, mod=1e9+7;

int add(int x, int y){
	return (x+y)%mod;
}

int mul(int x, int y){
	return 1LL*x*y%mod;
}

int fpow(int x, int p){
	int res=1;
	for(; p; p>>=1, x=1LL*x*x%mod) if(p&1) res=1LL*res*x%mod;
	return res%mod;
}

int inv(int x){
	return fpow(x, mod-2);
}

int fac[N];
int invfac[N];

void getFac(int n){
	fac[0]=invfac[0]=1;
	for(int i=1; i<=n; i++) fac[i]=1LL*fac[i-1]*i%mod, invfac[i]=1LL*invfac[i-1]*inv(i)%mod;
}

int C(int a, int b){
	if(b<0 || b>a) return 0;
	return 1LL*fac[a]*invfac[b]%mod*invfac[a-b]%mod;
}

int cal(int x, int y){
	return C(x+y, y);
}

void solve(){
	getFac(N-1);
	int n, m; cin>>n>>m;
	int a, b; cin>>a>>b;	
	int res=0;
	rep(j, b+1, m){
		// (n-a, j)
		res=add(res, mul(cal(n-a-1, j-1), cal(a-1, m-j)));
	}
	cout<<res<<"\n";
}

signed main(){
	solve();
	return 0;
}
```

</details>

