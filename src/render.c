#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_rect.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_surface.h>
#include <config.h>
#include <stdio.h>
#include <stdlib.h>
#include "render.h"

SDL_Renderer *renderer;
SDL_Window* window;
SDL_Texture* Texture;

SDL_Renderer* get_renderer(){
	return renderer;
}

SDL_Window* get_window(){
	return window;
}

void render_init(){
	SDL_Init(SDL_INIT_EVERYTHING);
	window = SDL_CreateWindow(WINDOW_TITLE, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1000, 1000, SDL_WINDOW_RESIZABLE);
	renderer = SDL_CreateRenderer(window, -1, 0);
}

void render_size(int w, int h){
	SDL_SetWindowSize(window, w, h);
}

void render_surface(SDL_Surface* Surface, SDL_Rect position){
	Texture = SDL_CreateTextureFromSurface(renderer, Surface);
	SDL_RenderCopy(renderer, Texture, NULL, &position);
}

SDL_Point get_window_size(){
	int x, y;
	SDL_GetWindowSize(window, &x, &y);
	SDL_Point window_size;
	window_size.x = x;
	window_size.y = y;
	return window_size;
}

SDL_Rect float_position(SDL_Surface* Surface, float y, float x, float w, float h){
	SDL_Rect position;
	position.h = (h/255 * Surface->h) / Surface->h * get_window_size().y * 2;
	position.y = y/255 * (get_window_size().y) - position.h / 2;
	position.w = (w/255 * Surface->w) / Surface->h * get_window_size().y * 2;
	position.x = (x/255 * get_window_size().x) - position.w / 2;
	return position;
}

SDL_Rect quick_rect(int y, int x, int w, int h){
	SDL_Rect position;
	position.h = h;
	position.w = w;
	position.x = x;
	position.y = y;
	return position;
}

void render_image(SDL_Surface* surface, SDL_Rect position){
	render_surface(surface, position);
}

void render_floating_image(SDL_Surface* surface, float y, float x, float w, float h){
	render_surface(surface, float_position(surface, y, x, w, h));
}

