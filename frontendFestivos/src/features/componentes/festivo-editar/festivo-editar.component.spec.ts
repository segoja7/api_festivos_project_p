import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FestivoEditarComponent } from './festivo-editar.component';

describe('FestivoEditarComponent', () => {
  let component: FestivoEditarComponent;
  let fixture: ComponentFixture<FestivoEditarComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [FestivoEditarComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(FestivoEditarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
