<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureAccessLevel
{
    /**
     * Handle an incoming request.
     *
     * @param  Closure(Request): (Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        if (! $request->user() || (int) $request->user()->access_level <= 0) {
            return response()->json([
                'message' => 'Unauthorized',
            ], 403);
        }

        return $next($request);
    }
}
