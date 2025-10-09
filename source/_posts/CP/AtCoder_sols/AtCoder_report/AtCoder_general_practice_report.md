---
title: AtCoder 泛刷记录
date: 2025-08-25 21:00:00
categories:
  - CP
  - AtCoder 题解
tags:
  - 解题合集
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


### ARC072D

定义 $\text{热量 E} = \text{体积 V} \times \text{温度 T}$。

- 题目特征明示维护一条曲线，$x$ 轴显然是体积 $v$，注意到维护热量比温度自然，故 $y$ 轴维护晚上能达到的最大热量 $e$。
- 考虑把题目的操作对应到维护的曲线上。
- 	假设某天的曲线为：
	<img src="1.png" width="35%" alt="">
	第二天加水时（这个状态是一个中间态，只是为了下一张图的阐述而服务）：
	<img src="2.png" width="35%" alt="">
	第二天的曲线为：
	<img src="3.png" width="35%" alt="">
- 可以发现当加入水温度（即斜率）比之前的低时，可以一直向后合并，这意味着合并后维护的曲线是一个上凸壳。

<details>

<summary>展开</summary>

```cpp
// Problem: F - Dam
// Contest: AtCoder - AtCoder Regular Contest 072
// URL: https://atcoder.jp/contests/arc072/tasks/arc072_d
// Memory Limit: 256 MB
// Time Limit: 3000 ms
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
using pid = pair<int, double>;
using ll = long long;
 
inline void read(int &x){
    int s=0; x=1;
    char ch=getchar();
    while(ch<'0' || ch>'9') {if(ch=='-')x=-1;ch=getchar();}
    while(ch>='0' && ch<='9') s=(s<<3)+(s<<1)+ch-'0',ch=getchar();
    x*=s;
}

const int N=5e5+5;

int n, m;

bool ok(pid &fir, pid &sec){
	double x=(double)fir.x*sec.y, y=fir.y*sec.x;
	return x>=y;
}

void solve(){
	cin>>n>>m;
	deque<pid> q;
	int sv=0;
	double se=0;
	rep(i, 1, n){
		int t, v; read(t), read(v);
		q.push_front({v, t*v});
		sv+=v;
		se+=t*v;
		while(q.size() && sv>=m){
			int x=q.back().x;
			double y=q.back().y;
			if(sv-x>=m) q.pop_back(), sv-=x, se-=y;
			else{
				double de=q.back().y*(sv-m)/q.back().x;
				se-=de;
				q.back().y-=de;
				q.back().x-=sv-m;
				sv=m;
				break;
			}
		}
		while(q.size()>=2){
			auto fir=q[0], sec=q[1];
			if(ok(fir, sec)){
				q.pop_front();
				q.pop_front();
				q.push_front({fir.x+sec.x, fir.y+sec.y});
			}
			else break;
		}
		printf("%.10lf\n", se/sv);
	}
}

signed main(){
	solve();
	return 0;
}
```

</details>

### ABC389E

- 贪心取，每个产品价格是无穷序列：$x, 3x, 5x ...$，那便是从 $n$ 个序列合并后的无穷升序序列 $A$ 中取数并最大化个数。
- 最优策略肯定是 $A$ 一个前缀。
- 从另一个角度看这个策略（即选取顺序）的特征发现：是依次把价格 $= 0, 1, 2 ...$ 的商品买空，直到边界，这支持二分。

<details>

<summary>展开</summary>

```cpp
// Problem: E - Square Price
// Contest: AtCoder - Toyota Programming Contest  2025（AtCoder Beginner Contest 389)
// URL: https://atcoder.jp/contests/abc389/tasks/abc389_e
// Memory Limit: 1024 MB
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
using lll = __int128;
 
inline void read(int &x){
    int s=0; x=1;
    char ch=getchar();
    while(ch<'0' || ch>'9') {if(ch=='-')x=-1;ch=getchar();}
    while(ch>='0' && ch<='9') s=(s<<3)+(s<<1)+ch-'0',ch=getchar();
    x*=s;
}

const int N=2e5+5;

int n, m;
int w[N];
int tmp, b[N];
lll last;

bool ok(int lim){
	tmp=0;
	last=m;
	rep(i, 1, n){
		int x=w[i];
		int t=(lim+x)/(x*2);
		tmp+=t;
		last-=(lll)t*t*x;
		b[i]=(t*2+1)*x;
		if(last<0) return false;
	}
	return true;
}

void solve(){
	cin>>n>>m;
	rep(i, 1, n) read(w[i]);
	int l=0, r=m;
	while(l<r){
		int mid=l+r+1>>1;
		if(ok(mid)) l=mid;
		else r=mid-1;
	}
	ok(l);
	int res=tmp;
	// debug(res);
	sort(b+1, b+1+n);
	rep(i, 1, n) if(last>=b[i]){
		last-=b[i];
		++res;
	}
	cout<<res<<"\n";
}

signed main(){
	solve();	
	return 0;
}
```

</details>

<!--
<details>

<summary>展开</summary>

</details>
!-->