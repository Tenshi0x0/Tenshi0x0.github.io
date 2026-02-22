---
title: 思维题泛刷记录
date: 2025-12-25 17:00:00
categories:
  - CP
  - 杂题题解
tags:
  - 解题合集
mathjax: true
---

## 简介

此文为本人泛刷思维题的简要题解，用以记录一些思维精彩的题。

> 折叠的代码中有原题链接方便跳转。（实现过于简单的题直接提供链接）

## 正文

### Luogu_P6075

[link](https://www.luogu.com.cn/problem/P6075)

题目中 $n$ 个元素可以看作 $n$ 种颜色。关键在于注意到每种颜色是独立的，可以分开考虑。

对于一种颜色，在图上染色的轮廓应为左上部分染而右下不染，而每种方案正好对应一条从左下角点出发到达对角线的右上顶点的路径。

如图所示：

<img src="Luogu_P6075_1.png" width="35%" alt="">

由于每条路径都是等长的，而且每次都有向上或者向右两种分支，所以单一颜色的贡献为 $2^k$，故答案为 $(2^k)^n = 2^{kn}$。

### CF1628C

可以发现决策位置对答案的贡献区域为**去心的四连通块**，故启发我们对棋盘进行二染色构造方案。

二染色方式如图所示：

<img src="CF1628C_1.png" width="35%" alt="">

注意到黑色部分和白色部分是左右对称的，所以只需要找到覆盖黑色部分的决策点集 $\{ (x, y) \}$ 后对应地操作 $\{ (x, n+1-y) \}$ 即可，剩下问题为找到一个简洁的覆盖黑色部分方案。

手玩 $n=4, 6$ 的例子：

<img src="CF1628C_2.png" width="35%" alt="">

<img src="CF1628C_3.png" width="35%" alt="">

可发现按对角线方向，拆成上下三角进行枚举比较方便：

<img src="CF1628C_4.png" width="35%" alt="">

参考实现：

```cpp
// Problem: C. Grid Xor
// Contest: Codeforces - Codeforces Round 767 (Div. 1)
// URL: https://codeforces.com/problemset/problem/1628/C
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
// #define int long long
#define vi vector<int>
#define pb push_back
#define all(x) (x).begin(), (x).end()
 
#define x first
#define y second
using pii = pair<int, int>;
using ll = long long;

void solve(){
	int n; cin>>n;
	vector<vi> w(n+1, vi(n+1));
	rep(i, 1, n) rep(j, 1, n) cin>>w[i][j];
	int res=0;
	
	auto upd=[&](int x, int y) -> void{
		res^=w[x][y];
	};
	
	auto OK=[&](int x, int y) -> bool{
		return x>=1 && x<=n && y>=1 && y<=n;
	};
	
	for(int val=1; val<=n/2; val+=2){
		for(int x=val, y=val; OK(x, y); x+=2, y-=2){
			upd(x, y);
			upd(x, n+1-y);
		}
		for(int x=val-2, y=val+2; OK(x, y); x-=2, y+=2){
			upd(x, y);
			upd(x, n+1-y);
		}
	}
	
	for(int val=n-1; val>n/2; val-=2){
		for(int x=val+1, y=val-1; OK(x, y); x+=2, y-=2){
			upd(x, y);
			upd(x, n+1-y);
		}
		for(int x=val-1, y=val+1; OK(x, y); x-=2, y+=2){
			upd(x, y);
			upd(x, n+1-y);
		}
	}
	
	cout<<res<<"\n";
}

signed main(){
	ios::sync_with_stdio(false);
	int cs; cin>>cs;
	while(cs--) solve();
	return 0;
}
```